-module(messenger_protocol).
-export([handle/3]).

handle(#{<<"type">> := <<"ping">>}, Req, State) ->
    {reply, jsx:encode(#{type => pong}), Req, State};
handle(#{<<"type">> := <<"im">>} = IncomingMessage, Req, State) ->
    im(IncomingMessage, Req, State);
handle(#{<<"type">> := <<"comments">>} = IncomingMessage, Req, State) ->
    comments(IncomingMessage, Req, State);
handle(IncomingMessage, Req, State) ->
    lager:error("Can't handle message: ~p", [IncomingMessage]),
    {ok, Req, State}.

im(
    #{<<"conversation_id">> := ConversationId} = IncomingMessage, Req,
    #{user_id := UserId} = State
) ->
    case messenger_persistence:is_belong_to_conversation(UserId, ConversationId) of
        false ->
            lager:error("User#~p has tried to access Conversation#~p but he does't belong to it", [UserId, ConversationId]),
            {ok, Req, State};
        true ->
            im_authorized(IncomingMessage, Req, State)
    end.

im_authorized(#{
    <<"command">>         := <<"list">>,
    <<"conversation_id">> := ConversationId
} = IncomingMessage, Req, State) ->
    SinceId = maps:get(<<"since_id">>, IncomingMessage, 0),
    Count   = maps:get(<<"count">>, IncomingMessage, 10),
    OutgoingMessage = jsx:encode(#{
        type => im,
        command => list,
        payload => messenger_persistence:messages(ConversationId, SinceId, Count)
    }),
    {reply, OutgoingMessage, Req, State};
im_authorized(#{
    <<"command">>         := <<"send">>,
    <<"text">>            := Text,
    <<"conversation_id">> := ConversationId
}, Req, #{user_id := UserId} = State) ->
    ok = messenger_channels:send_message(UserId, ConversationId, Text),
    {ok, Req, State};
im_authorized(#{
    <<"command">>         := <<"online_list">>,
    <<"conversation_id">> := ConversationId
}, Req, State) ->
    OutgoingMessage = jsx:encode(#{
        type    => im,
        command => online_list,
        payload => messenger_channels:online_list(ConversationId)
    }),
    {reply, OutgoingMessage, Req, State};
im_authorized(#{
    <<"command">>    := <<"mark_read">>,
    <<"message_id">> := MessageId
}, Req, #{user_id := UserId} = State) ->
    {ok, _} = messenger_persistence:mark_read(UserId, MessageId),
    {ok, Req, State};
im_authorized(IncomingMessage, Req, State) ->
    lager:error("Can't handle message: ~p", [IncomingMessage]),
    {ok, Req, State}.

comments(#{
    <<"command">>       := <<"list">>,
    <<"resource_type">> := ResourceType,
    <<"resource_id">>   := ResourceId
} = IncomingMessage, Req, State) ->
    SinceId = maps:get(<<"since_id">>, IncomingMessage, 0),
    Count   = maps:get(<<"count">>, IncomingMessage, 10),
    OutgoingMessage = jsx:encode(#{
        type => comments,
        command => list,
        payload => messenger_persistence:comments(ResourceType, ResourceId, SinceId, Count)
    }),
    {reply, OutgoingMessage, Req, State};
comments(#{
    <<"command">>       := <<"subscribe">>,
    <<"resource_type">> := ResourceType,
    <<"resource_id">>   := ResourceId
}, Req, State) ->
    ok = messenger_comments:subscribe(ResourceType, ResourceId),
    {ok, Req, State};
comments(#{
    <<"command">>       := <<"post">>,
    <<"resource_type">> := ResourceType,
    <<"resource_id">>   := ResourceId,
    <<"body">>          := Body
}, Req, #{user_id := UserId} = State) ->
    Comment = messenger_persistence:store_comment(ResourceType, ResourceId, UserId, Body),
    ok = messenger_comments:notify(ResourceType, ResourceId, Comment),
    {ok, Req, State};
comments(IncomingMessage, Req, State) ->
    lager:error("Can't handle message: ~p", [IncomingMessage]),
    {ok, Req, State}.
