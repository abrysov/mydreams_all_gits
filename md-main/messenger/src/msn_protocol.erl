-module(msn_protocol).
-export([handle/3]).

handle(#{<<"type">> := <<"ping">>} = IncomingMessage, Req, State) ->
    reply(#{type => pong}, IncomingMessage, Req, State);
handle(#{<<"type">> := <<"im">>} = IncomingMessage, Req, State) ->
    im(IncomingMessage, Req, State);
handle(#{<<"type">> := <<"comments">>} = IncomingMessage, Req, State) ->
    comments(IncomingMessage, Req, State);
handle(IncomingMessage, Req, State) ->
    lager:error("Can't handle message: ~p", [IncomingMessage]),
    noreply(IncomingMessage, Req, State).

im(
    #{<<"conversation_id">> := ConversationId} = IncomingMessage, Req,
    #{user_id := UserId} = State
) ->
    case msn_persistence:is_belong_to_conversation(UserId, ConversationId) of
        false ->
            lager:error("User#~p has tried to access Conversation#~p but he does't belong to it", [UserId, ConversationId]),
            {ok, Req, State};
        true ->
            im_authorized(IncomingMessage, Req, State)
    end.

im_authorized(#{
    <<"command">>         := <<"list">>,
    <<"conversation_id">> := ConversationId
} = IncomingMessage, Req, #{user_id := UserId} = State) ->
    SinceId = maps:get(<<"since_id">>, IncomingMessage, 0),
    Count   = maps:get(<<"count">>, IncomingMessage, 10),
    Reply   = #{
        type => im,
        command => list,
        payload => #{
            conversation_id => ConversationId,
            messages => msn_persistence:messages(UserId, ConversationId, SinceId, Count),
            since_id => SinceId
        }
    },
    reply(Reply, IncomingMessage, Req, State);
im_authorized(#{
    <<"command">>         := <<"send">>,
    <<"message">>         := Text,
    <<"conversation_id">> := ConversationId
} = IncomingMessage, Req, #{user_id := UserId} = State) ->
    Attachments = maps:get(<<"attachments">>, IncomingMessage, []),
    Message = msn_persistence:store_message(UserId, ConversationId, Text, Attachments),
    ok = msn_channels:bcast_message({send_message, Message}, ConversationId),
    ok = msn_embed_worker:process_message(Message),
    noreply(IncomingMessage, Req, State);
im_authorized(#{
    <<"command">>         := <<"online_list">>,
    <<"conversation_id">> := ConversationId
} = IncomingMessage, Req, State) ->
    Reply = #{
        type    => im,
        command => online_list,
        payload => msn_channels:online_list(ConversationId)
    },
    reply(Reply, IncomingMessage, Req, State);
im_authorized(#{
    <<"command">>    := <<"mark_read">>,
    <<"message_id">> := MessageId
} = IncomingMessage, Req, #{user_id := UserId} = State) ->
    ok = msn_persistence:mark_read(UserId, MessageId),
    noreply(IncomingMessage, Req, State);
im_authorized(IncomingMessage, Req, State) ->
    lager:error("Can't handle message: ~p", [IncomingMessage]),
    noreply(IncomingMessage, Req, State).

comments(#{
    <<"command">>       := <<"list">>,
    <<"resource_type">> := ResourceType,
    <<"resource_id">>   := ResourceId
} = IncomingMessage, Req, State) ->
    SinceId = maps:get(<<"since_id">>, IncomingMessage, 0),
    Count   = maps:get(<<"count">>, IncomingMessage, 10),
    Reply   = #{
        type => comments,
        command => list,
        payload => #{
            resource_id => ResourceId,
            resource_type => ResourceType,
            since_id => SinceId,
            comments => msn_persistence:comments(ResourceType, ResourceId, SinceId, Count)
        }
    },
    reply(Reply, IncomingMessage, Req, State);
comments(#{
    <<"command">>       := <<"subscribe">>,
    <<"resource_type">> := ResourceType,
    <<"resource_id">>   := ResourceId
} = IncomingMessage, Req, State) ->
    ok = msn_comments:subscribe({ResourceType, ResourceId}),
    noreply(IncomingMessage, Req, State);
comments(#{
    <<"command">>       := <<"unsubscribe">>,
    <<"resource_type">> := ResourceType,
    <<"resource_id">>   := ResourceId
} = IncomingMessage, Req, State) ->
    ok = msn_comments:unsubscribe({ResourceType, ResourceId}),
    noreply(IncomingMessage, Req, State);
comments(#{
    <<"command">>       := <<"post">>,
    <<"resource_type">> := ResourceType,
    <<"resource_id">>   := ResourceId,
    <<"body">>          := Body
} = IncomingMessage, Req, #{user_id := UserId} = State) ->
    Comment = msn_persistence:store_comment(ResourceType, ResourceId, UserId, Body),
    ok = msn_comments:notify({ResourceType, ResourceId}, {comment, Comment}),
    noreply(IncomingMessage, Req, State);
comments(#{
    <<"command">>    := <<"add_reaction">>,
    <<"comment_id">> := CommentId,
    <<"reaction">>   := Reaction
} = IncomingMessage, Req, #{user_id := UserId} = State) ->
    CommentReaction = msn_persistence:store_comment_reaction(CommentId, UserId, Reaction),
    CommentResource = msn_persistence:comment_resource(CommentId),
    ok = msn_comments:notify(CommentResource, {add_reaction, CommentReaction}),
    noreply(IncomingMessage, Req, State);
comments(IncomingMessage, Req, State) ->
    lager:error("Can't handle message: ~p", [IncomingMessage]),
    noreply(IncomingMessage, Req, State).

reply(Reply, IncomingMessage, Req, State) ->
    Reply1 = case maps:get(<<"id">>, IncomingMessage, noid) of
        noid -> Reply;
        Id   -> maps:put(reply_to, Id, Reply)
    end,
    OutgoingMessage = jsx:encode(Reply1),
    lager:debug("Reply: ~ts", [OutgoingMessage]),
    {reply, OutgoingMessage, Req, State}.

noreply(_IncomingMessage, Req, State) ->
    {ok, Req, State}.
