-module(messenger_persistence).
-export ([store_message/3
         ,last_messages/2
         ,find_conversation/1
         ,conversation_members/1
         ,mark_read/2]).

-define(POOL_NAME, mydreams).

store_message(From, ConversationId, Text) ->
    {ok, _Cnt, ColumnNames, Rows} = pgapp:equery(?POOL_NAME,
        get_query(messages, store_message), [ConversationId, From, Text]),
    [#{<<"id">> := Id}|_] = convert_to_map(ColumnNames, Rows),
    {ok, ColumnNames1, Rows1} = pgapp:equery(?POOL_NAME,
        get_query(messages, find_message), [Id]),
    lists:last(convert_to_map(ColumnNames1, Rows1)).

last_messages(ConversationId, Count) ->
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, get_query(messages, last_messages),
        [ConversationId, Count]),
    convert_to_map(ColumnNames, Rows).

mark_read(UserId, MessageId) ->
    Select = get_query(messages, viewed_ids_with_lock),
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, Select, [MessageId]),
    [M|_] = convert_to_map(ColumnNames, Rows),
    NewViewedIds = case maps:get(<<"viewed_ids">>, M) of
        null ->
            [UserId];
        ViewedIds ->
            lists:usort([UserId|ViewedIds])
    end,
    Update = get_query(messages,  update_viewed_ids),
    {ok, _Cnt} = pgapp:equery(?POOL_NAME, Update, [NewViewedIds, MessageId]).

find_conversation(ConversationId) ->
    Query = get_query(conversations, find),
    {ok, ColumnNames, Rows} = pgapp:equery(?POOL_NAME, Query, [ConversationId]),
    [Conversation] = convert_to_map(ColumnNames, Rows),
    Conversation.

conversation_members(ConversationId) ->
    maps:get(<<"member_ids">>, find_conversation(ConversationId)).

%% private
convert_to_map(ColumnNames, Rows) ->
    lists:map(fun(Row) ->
        lists:foldl(fun({{column, Name, _Type, _, _, _}, Value}, Map) ->
            maps:put(Name, Value, Map)
        end, maps:new(), lists:zip(ColumnNames, tuple_to_list(Row)))
    end, Rows).

%% private
get_query(File, Name) ->
    Path = filename:join([code:priv_dir(messenger), sql, [File, ".sql"]]),
    {ok, Queries} = eql:compile(Path),
    eql:get_query(Name, Queries).

