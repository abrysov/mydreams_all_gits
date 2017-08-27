-module(messenger_persistence).
-export([messages/3
        ,store_message/3
        ,find_conversation/1
        ,conversation_members/1
        ,is_belong_to_conversation/2
        ,mark_read/2
        ,comments/4
        ,store_comment/4]).

-define(POOL_NAME, mydreams).

messages(ConversationId, SinceId, Count) ->
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, query(messages, collection),
        [ConversationId, SinceId, Count]),
    with_avatar(convert_to_map(ColumnNames, Rows)).

store_message(From, ConversationId, Text) ->
    {ok, _Cnt, ColumnNames, Rows} = pgapp:equery(?POOL_NAME,
        query(messages, store), [ConversationId, From, Text]),
    [#{<<"id">> := Id}|_] = convert_to_map(ColumnNames, Rows),
    {ok, ColumnNames1, Rows1} = pgapp:equery(?POOL_NAME,
        query(messages, find), [Id]),
    [Message] = convert_to_map(ColumnNames1, Rows1),
    with_avatar(Message).

mark_read(UserId, MessageId) ->
    Select = query(messages, viewed_ids_with_lock),
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, Select, [MessageId]),
    [M|_] = convert_to_map(ColumnNames, Rows),
    NewViewedIds = case maps:get(<<"viewed_ids">>, M) of
        null ->
            [UserId];
        ViewedIds ->
            lists:usort([UserId|ViewedIds])
    end,
    Update = query(messages,  update_viewed_ids),
    {ok, _Cnt} = pgapp:equery(?POOL_NAME, Update, [NewViewedIds, MessageId]).

find_conversation(ConversationId) ->
    Query = query(conversations, find),
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, Query, [ConversationId]),
    [Conversation] = convert_to_map(ColumnNames, Rows),
    Conversation.

conversation_members(ConversationId) ->
    maps:get(<<"member_ids">>, find_conversation(ConversationId)).

is_belong_to_conversation(UserId, ConversationId) ->
    Query = query(conversations, belongs),
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, Query, [UserId, ConversationId]),
    [#{<<"result">> := Result}] = convert_to_map(ColumnNames, Rows),
    Result.

comments(ResourceType, ResourceId, SinceId, Count) ->
    Query = query(comments, collection),
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, Query,
        [ResourceType, ResourceId, SinceId, Count]),
    with_avatar(convert_to_map(ColumnNames, Rows)).

store_comment(ResourceType, ResourceId, UserId, Body) ->
    {ok, _Cnt, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, query(comments, store),
        [ResourceType, ResourceId, UserId, Body]),
    [#{<<"id">> := Id}|_] = convert_to_map(ColumnNames, Rows),
    {ok, ColumnNames1, Rows1} = pgapp:equery(?POOL_NAME, query(comments, find), [Id]),
    [Comment] = convert_to_map(ColumnNames1, Rows1),
    with_avatar(Comment).

with_avatar(Messages) when is_list(Messages) ->
    [with_avatar(M) || M <- Messages];
with_avatar(Message) when is_map(Message) ->
    DreamerId = maps:get(<<"dreamer_id">>, Message),
    FileName  = maps:get(<<"avatar_new">>, Message),
    AvatarUrl = messenger_avatar:url(DreamerId, FileName),
    maps:put(<<"avatar">>, AvatarUrl, maps:remove(<<"avatar_new">>, Message)).

%% private
convert_to_map(ColumnNames, Rows) ->
    lists:map(fun(Row) ->
        lists:foldl(fun({{column, Name, _Type, _, _, _}, Value}, Map) ->
            maps:put(Name, Value, Map)
        end, maps:new(), lists:zip(ColumnNames, tuple_to_list(Row)))
    end, Rows).

%% private
query(File, Name) ->
    Path = filename:join([code:priv_dir(messenger), sql, [File, ".sql"]]),
    {ok, Queries} = eql:compile(Path),
    eql:get_query(Name, Queries).

