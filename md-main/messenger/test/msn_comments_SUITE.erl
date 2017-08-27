-module(msn_comments_SUITE).
-include_lib("common_test/include/ct.hrl").

-define(TESTEE_MOD, msn_comments).

-export([all/0
        ,groups/0
        ,init_per_suite/1
        ,end_per_suite/1
        ,init_per_group/2
        ,end_per_group/2
        ,init_per_testcase/2
        ,end_per_testcase/2]).

-export([subscribe_test/1
        ,unsubscribe_test/1]).

all() ->
    [
        {group, comments}
    ].

groups() ->
    [
        {comments, [parallel, {repeat, 10}], [
            subscribe_test,
            unsubscribe_test
        ]}
    ].

init_per_suite(Config) ->
    _ = application:start(gproc),
    ok = lists:foreach(fun(Mod) ->
        {ok, Pid} = Mod:start_link(),
        unlink(Pid)
    end, [
        msn_comment_resources_sup,
        msn_comments
    ]),
    Config.

end_per_suite(_Config) ->
    lists:foreach(fun (Proc) ->
        Pid = whereis(Proc),
        exit(Pid, kill)
    end, [
        msn_comment_resources_sup,
        msn_comments
    ]).

init_per_group(comments, Config) ->
    Config.

end_per_group(comments, _Config) ->
    ok.

init_per_testcase(_TestCase, Config) ->
    Config.

end_per_testcase(_TestCase, _Config) ->
    ok.

subscribe_test(_Config) ->
    ok = ?TESTEE_MOD:subscribe({testresource, 1}),
    ok = ?TESTEE_MOD:notify({testresource, 1}, {cmt, testcomment}),
    ok = receive
        {cmt, testcomment} -> ok
        after 1 -> timeout
    end.

unsubscribe_test(_Config) ->
    ok = ?TESTEE_MOD:subscribe({testresource, 2}),
    ok = ?TESTEE_MOD:unsubscribe({testresource, 2}),
    ok = ?TESTEE_MOD:notify({testresource, 2}, it_will_never_received),
    ok = receive
        _Message -> unexpected_message
        after 0 -> ok
    end.
