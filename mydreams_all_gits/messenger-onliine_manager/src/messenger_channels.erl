-module(messenger_channels).

-export([reg_channel/1
        ,on_process_exit_callback/3
        ,online_list/1
        ,send_message/3]).

reg_channel(Id) ->
    Pid = self(),
    lager:debug("Register process ~p with key ~p", [Pid, {channel, Id}]),
    syn:join({channel, Id}, Pid),
    messenger_online_manager:notify_online(Id).

on_process_exit_callback({channel, Id}, _Pid, _Reason) ->
    lager:debug("on_process_exit_callback {channel, ~p}", [Id]),
    messenger_online_manager:notify_offline(Id);
on_process_exit_callback(Key, Pid, Reason) ->
    lager:debug("on_process_exit_callback(~p, ~p, ~p, ~p)", [Key, Pid, Reason]),
    ok.

send_message(From, ConversationId, Text) ->
    Message = messenger_persistence:store_message(From, ConversationId, Text),
    lists:foreach(fun(Pid) ->
        Pid ! {send_message, Message}
    end, conversation_channels(ConversationId)).

online_list(ConversationId) ->
    Members = messenger_persistence:conversation_members(ConversationId),
    messenger_online_manager:subscribe(Members),
    lists:filter(fun is_online/1, Members).

%% private
conversation_channels(ConversationId) ->
    Members = messenger_persistence:conversation_members(ConversationId),
    lists:flatten(lists:map(fun get_channels/1, Members)).

%% private
get_channels(UserId) ->
    syn:get_members({channel, UserId}).

%% private
is_online(UserId) ->
    [] =/= get_channels(UserId).
