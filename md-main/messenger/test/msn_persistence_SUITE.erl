-module(msn_persistence_SUITE).
-include_lib("common_test/include/ct.hrl").

-define(TESTEE_MOD, msn_persistence).

-define(COMMENTABLE_ID, 1).
-define(COMMENTABLE_TYPE, <<"Dream">>).

-export([all/0
        ,groups/0
        ,init_per_suite/1
        ,end_per_suite/1
        ,init_per_group/2
        ,end_per_group/2
        ,init_per_testcase/2
        ,end_per_testcase/2]).

-export([store_comment_reaction_test/1
        ,comments_test/1
        ,store_message_test/1]).

all() -> [
    comments_test,
    store_message_test,
    store_comment_reaction_test
].
groups() -> [].

init_per_suite(Config) ->
    {ok, _Apps} = application:ensure_all_started(pgapp),
    {ok, _Pid}  = pgapp:connect(mydreams, [
        {host,     "localhost"},
        {database, "mydreams_test"},
        {username, "postgres"},
        {password, ""}
    ]),
    ok = cleanup(),
    Config.

end_per_suite(_Config) ->
    ok.

init_per_group(_Group, Config) -> Config.
end_per_group(_Group, _Config) -> ok.

init_per_testcase(store_message_test, Config) ->
    MemberIds = [create_dreamer() || _ <- lists:seq(1, 3)],
    ConversationId = created_conversation(MemberIds),
    [
        {member_ids, MemberIds},
        {conversation_id, ConversationId}
    ] ++ Config;
init_per_testcase(store_comment_reaction_test, Config) ->
    DreamerId = create_dreamer(),
    CommentId = create_comment(DreamerId),
    [
        {dreamer_id, DreamerId},
        {comment_id, CommentId}
    ] ++ Config;
init_per_testcase(comments_test, Config) ->
    [{dreamer_id, create_dreamer()} | Config];
init_per_testcase(_TestCase, Config) ->
    Config.

end_per_testcase(_TestCase, _Config) ->
    cleanup().

store_comment_reaction_test(Config) ->
    DreamerId = ?config(dreamer_id, Config),
    CommentId = ?config(comment_id, Config),
    ?TESTEE_MOD:store_comment_reaction(CommentId, DreamerId, <<"hankey">>).

comments_test(Config) ->
    DreamerId = ?config(dreamer_id, Config),
    Id1 = create_comment(DreamerId),
    Id2 = create_comment(DreamerId),
    ?TESTEE_MOD:store_comment_reaction(Id1, DreamerId, <<"hankey">>),
    Comments = ?TESTEE_MOD:comments(?COMMENTABLE_TYPE, ?COMMENTABLE_ID, 0, 10),
    2 = length(Comments),
    [Id1, Id2] = [maps:get(<<"id">>, X) || X <- Comments],
    [[Reaction], []] = [maps:get(<<"reactions">>, X) || X <- Comments],
    <<"hankey">> = maps:get(<<"reaction">>, Reaction).

store_message_test(Config) ->
    [From | _] = ?config(member_ids, Config),
    ConversationId = ?config(conversation_id, Config),
    AttachmentId = created_attachment(),
    Message = ?TESTEE_MOD:store_message(From, ConversationId, <<"Привет">>, [AttachmentId]),
    #{<<"id">> := MessageId, <<"attachments">> := [Attachment]} = Message,
    #{<<"id">> := AttachmentId} = Attachment,
    assert_attachment_is_bound_to_message(AttachmentId, MessageId),
    Conversation = ?TESTEE_MOD:find_conversation(ConversationId),
    {UpdatedAt, _} = maps:get(<<"updated_at">>, Conversation),
    {Today, _} = calendar:local_time(),
    Today = UpdatedAt.

cleanup() ->
    {ok, _} = pgapp:squery(mydreams, "DELETE FROM reactions"),
    {ok, _} = pgapp:squery(mydreams, "DELETE FROM comments"),
    {ok, _} = pgapp:squery(mydreams, "DELETE FROM attachments"),
    {ok, _} = pgapp:squery(mydreams, "DELETE FROM messages"),
    {ok, _} = pgapp:squery(mydreams, "DELETE FROM conversations"),
    {ok, _} = pgapp:squery(mydreams, "DELETE FROM dreamers"),
    ok.

create_dreamer() ->
    {ok, _Cnt, _Columns, [{DreamerId}]} = pgapp:equery(mydreams, "
        INSERT INTO dreamers(first_name, last_name, created_at, updated_at)
        VALUES ($1, $2, now(), now())
        RETURNING id
    ", [<<"John">>, <<"Doe">>]),
    DreamerId.

create_comment(DreamerId) ->
    {ok, _Cnt, _Columns, [{CommentId}]} = pgapp:equery(mydreams, "
        INSERT INTO comments(commentable_id, commentable_type,
            dreamer_id, body, created_at, updated_at)
        VALUES ($1, $2, $3, $4, now(), now())
        RETURNING id
    ", [?COMMENTABLE_ID, ?COMMENTABLE_TYPE, DreamerId, <<"Первый нах">>]),
    CommentId.

created_attachment() ->
    {ok, _Cnt, _Columns, [{AttachmentId}]} = pgapp:equery(mydreams, "
        INSERT INTO attachments(file_new, created_at, updated_at)
        VALUES ($1, now(), now())
        RETURNING id
    ", [<<"kittens.jpg">>]),
    AttachmentId.

created_conversation(MemberIds) ->
    {ok, _Cnt, _Columns, [{ConversationId}]} = pgapp:equery(mydreams, "
        INSERT INTO conversations(member_ids, created_at, updated_at)
        VALUES ($1, now() - interval '1 month', now() - interval '1 week')
        RETURNING id
    ", [MemberIds]),
    ConversationId.

assert_attachment_is_bound_to_message(AttachmentId, MessageId) ->
    {ok, _Columns, [{1}]} = pgapp:equery(mydreams, "
        SELECT 1
        FROM attachments
        WHERE id = $1
        AND attachmentable_id = $2
        AND attachmentable_type = 'Message'
    ", [AttachmentId, MessageId]).
