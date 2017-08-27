-module(msn_persistence).
-export([messages/4
        ,store_message/3
        ,store_message/4
        ,find_conversation/1
        ,conversation_members/1
        ,is_belong_to_conversation/2
        ,mark_read/2
        ,comments/4
        ,comment_resource/1
        ,store_comment/4
        ,store_comment_reaction/3
        ,set_online/1
        ,set_offline/1
        ,feedback/1]).

-include_lib("epgsql/include/epgsql.hrl").

-define(POOL_NAME, mydreams).

messages(UserId, ConversationId, 0, Count) ->
    with_avatar(exec(messages, initial_collection, [UserId, ConversationId, Count]));
messages(UserId, ConversationId, SinceId, Count) ->
    with_avatar(exec(messages, previous_collection, [UserId, ConversationId, SinceId, Count])).

store_message(From, ConversationId, Text) ->
    MessageId = pgapp:with_transaction(?POOL_NAME, fun() ->
        [#{<<"id">> := Id}] = exec(messages, store, [ConversationId, From, Text]),
        exec(conversations, touch, [ConversationId]),
        Id
    end),
    [Message] = exec(messages, find, [MessageId]),
    with_avatar(Message).

store_message(From, ConversationId, Text, []) ->
    store_message(From, ConversationId, Text);
store_message(From, ConversationId, Text, AttachmentIds) ->
    #{<<"id">> := MessageId} = Message = store_message(From, ConversationId, Text),
    ok = exec(attachments, bind_to_message, [MessageId, AttachmentIds]),
    Attachments = with_attachment_url(exec(attachments, collection, [AttachmentIds, MessageId])),
    maps:put(<<"attachments">>, Attachments, Message).

mark_read(UserId, MessageId) ->
    exec(messages, update_viewed_ids, [UserId, MessageId]).

find_conversation(ConversationId) ->
    [Conversation] = exec(conversations, find, [ConversationId]),
    Conversation.

conversation_members(ConversationId) ->
    maps:get(<<"member_ids">>, find_conversation(ConversationId)).

is_belong_to_conversation(UserId, ConversationId) ->
    [#{
        <<"result">> := Result
    }] = exec(conversations, belongs, [UserId, ConversationId]),
    Result.

comments(ResourceType, ResourceId, SinceId, Count) ->
    Comments = with_avatar(exec(comments, collection,
        [ResourceId, convert_resource_type(ResourceType), SinceId, Count])),
    CommentIds = [maps:get(<<"id">>, C) || C <- Comments],
    Reactions = load_reactions_for_comments(CommentIds),
    lists:map(fun(Comment) ->
        Id = maps:get(<<"id">>, Comment),
        CommentReactions = maps:get(Id, Reactions, []),
        maps:put(<<"reactions">>, CommentReactions, Comment)
    end, Comments).

convert_resource_type(<<"post">>) -> <<"Post">>;
convert_resource_type(<<"dream">>) -> <<"Dream">>;
convert_resource_type(ResourceType) -> ResourceType.

update_cache_counter_query(<<"post">>) -> update_posts_cache_counter;
update_cache_counter_query(<<"dream">>) -> update_dreams_cache_counter;
update_cache_counter_query(_ResourceType) -> none.

store_comment(ResourceType, ResourceId, UserId, Body) ->
    CommentId = pgapp:with_transaction(?POOL_NAME, fun() ->
        [#{<<"id">> := Id}] = exec(comments, store,
             [ResourceId, convert_resource_type(ResourceType), UserId, Body]),
        exec(comments, update_cache_counter_query(ResourceType), [ResourceId]),
        Id
    end),

    [Comment] = exec(comments, find, [CommentId]),
    with_avatar(Comment).

store_comment_reaction(CommentId, UserId, Reaction) ->
    [#{
        <<"id">> := Id
    }] = exec(reactions, store, [CommentId, <<"Comment">>, UserId, Reaction]),
    exec(reactions, find, [Id]).

set_online(DreamerId) ->
    exec(dreamers, set_online, [DreamerId]).

set_offline(DreamerId) ->
    lager:debug("~s:set_offline(~p) called", [?MODULE, DreamerId]),
    exec(dreamers, set_offline, [DreamerId]).

%% TODO: Nuke feedbacks
feedback(Id) ->
    case exec(feedbacks, find, [Id]) of
        [] ->
            undefined;
        [Feedback] ->
            #{
                <<"resource_type">> := ResourceType,
                <<"resource_id">>   := ResourceId
            } = Feedback,
            EntityType = resource_type2entity_type(ResourceType),
            lists:foldl(fun(Fun, Acc) -> Fun(Acc) end, Feedback, [
                fun(M) -> maps:without([<<"resource_type">>, <<"resource_id">>], M) end,
                fun(M) -> maps:put(<<"entity_type">>, EntityType, M) end,
                fun(M) -> maps:put(<<"entity_id">>, ResourceId, M) end
            ])
    end.

resource_type2entity_type(<<"TopDream">>) ->
    <<"top_dream">>;
resource_type2entity_type(ResourceType) ->
    list_to_binary(string:to_lower(binary_to_list(ResourceType))).

comment_resource(CommentId) ->
    #{
        <<"commentable_type">> := CommentableType,
        <<"commentable_id">>   := CommentableId
    } = exec(comments, comment_resource, [CommentId]),
    {CommentableType, CommentableId}.

with_avatar(Messages) when is_list(Messages) ->
    [with_avatar(M) || M <- Messages];
with_avatar(Message) when is_map(Message) ->
    DreamerId     = maps:get(<<"dreamer_id">>, Message),
    DreamerGender = maps:get(<<"dreamer_gender">>, Message),
    FileName      = maps:get(<<"avatar">>, Message),
    AvatarUrl     = msn_files:avatar(DreamerId, FileName, DreamerGender),
    maps:put(<<"dreamer_avatar">>, AvatarUrl, maps:remove(<<"avatar">>, Message)).

with_attachment_url(Attachments) when is_list(Attachments) ->
    [with_attachment_url(A) || A <- Attachments];
with_attachment_url(Attachment) when is_map(Attachment) ->
    AttachmentId = maps:get(<<"id">>, Attachment),
    FileName = maps:get(<<"file">>, Attachment),
    AttachmentUrl = msn_files:attachment(AttachmentId, FileName),
    maps:put(<<"url">>, AttachmentUrl, maps:remove(<<"file">>, Attachment)).

load_reactions_for_comments([]) ->
    [];
load_reactions_for_comments(CommentIds) ->
    Reactions = exec(reactions, for_comments, [<<"Comment">>, CommentIds]),
    group_reactions_by_comment(Reactions).

group_reactions_by_comment(Reactions) ->
    lists:foldl(fun(Reaction0, Acc) ->
        CommentId = maps:get(<<"comment_id">>, Reaction0),
        Reaction = maps:remove(<<"comment_id">>, Reaction0),
        CommentReactions = maps:get(CommentId, Acc, []),
        maps:put(CommentId, [Reaction | CommentReactions], Acc)
    end, #{}, Reactions).

exec(Table, QueryName, Params) ->
    Query = get_query(Table, QueryName),
    equery(Query, Params).

get_query(File, Name) ->
    Path = filename:join([code:priv_dir(messenger), sql, [File, ".sql"]]),
    {ok, Queries} = eql:compile(Path),
    eql:get_query(Name, Queries).

equery(Query, Params) ->
    case pgapp:equery(?POOL_NAME, Query, Params) of
        {ok, _Cnt} ->
            ok;
        {ok, ColumnNames, Rows} ->
            convert_to_map(ColumnNames, Rows);
        {ok, _Cnt, ColumnNames, Rows} ->
            convert_to_map(ColumnNames, Rows)
    end.

convert_to_map(ColumnNames, Rows) ->
    lists:map(fun(Row) ->
        lists:foldl(fun({#column{ name = Name }, Value}, Map) ->
            maps:put(Name, Value, Map)
        end, maps:new(), lists:zip(ColumnNames, tuple_to_list(Row)))
    end, Rows).
