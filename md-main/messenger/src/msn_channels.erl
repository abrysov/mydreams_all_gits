-module(msn_channels).

-export([reg_channel/2
        ,online_list/1
        ,send_to_user/2
        ,bcast_message/2
        ,get_channels/1
        ,is_online/1
        ,all/0
        ,total_count/0]).

-define(MATCH_HEAD, {{p, l, {channel, '$1'}}, '$2', '$3'}).
-define(MATCH_SPEC, [{?MATCH_HEAD, [], [true]}]).

reg_channel(Id, Props0) ->
    Props = maps:put(started_at, erlang:system_time(seconds), Props0),
    gproc:reg({p, l, {channel, Id}}, Props).

send_to_user(Message, UserId) ->
    lists:foreach(fun(Pid) ->
        Pid ! Message
    end, get_channels(UserId)).

bcast_message(Message, ConversationId) ->
    lists:foreach(fun(Pid) ->
        Pid ! Message
    end, conversation_channels(ConversationId)).

online_list(ConversationId) ->
    Members = msn_persistence:conversation_members(ConversationId),
    lists:filter(fun is_online/1, Members).

all() ->
    Selected = gproc:select({l, p}, ?MATCH_SPEC),
    lists:map(fun([{p, l, {channel, UserId}}, _Pid, Props]) ->
        StartedAt = maps:get(started_at, Props),
        maps:merge(#{
            user_id => UserId,
            duration => since(StartedAt)
        }, Props)
    end, Selected).

total_count() ->
    gproc:select_count(?MATCH_SPEC).

conversation_channels(ConversationId) ->
    Members = msn_persistence:conversation_members(ConversationId),
    lists:flatten(lists:map(fun get_channels/1, Members)).

get_channels(UserId) ->
    gproc:lookup_pids({p, l, {channel, UserId}}).

is_online(UserId) ->
    [] =/= get_channels(UserId).

since(Ts) ->
    Seconds = erlang:system_time(seconds) - Ts,
    compaund_duration(Seconds).

compaund_duration(SecondsTotal) ->
    {Days, {Hours, Minutes, Seconds}} = calendar:seconds_to_daystime(SecondsTotal),
    Mapping = [
        {"d", Days},
        {"hr", Hours},
        {"min", Minutes},
        {"sec", Seconds}
    ],
    Parts = lists:filtermap(fun({Unit, Value}) ->
        case Value of
            0 -> false;
            _ -> {true, string:join([integer_to_list(Value), Unit], " ")}
        end
    end, Mapping),
    list_to_binary(string:join(Parts, ", ")).

