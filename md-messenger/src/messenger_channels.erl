-module(messenger_channels).

-export([reg_channel/1
        ,online_list/1
        ,send_message/3]).

reg_channel(Id) ->
    gproc:reg({p, l, {channel, Id}}).

send_message(From, ConversationId, Text) ->
    Message = messenger_persistence:store_message(From, ConversationId, Text),
    lists:foreach(fun(Pid) ->
        Pid ! {send_message, Message}
    end, conversation_channels(ConversationId)).

online_list(ConversationId) ->
    Members = messenger_persistence:conversation_members(ConversationId),
    ok = lists:foreach(fun(UserId) ->
        lager:debug("Channels for ~p are ~p", [UserId, get_channels(UserId)])
    end, Members),
    lists:filter(fun is_online/1, Members).

%% private
conversation_channels(ConversationId) ->
    Members = messenger_persistence:conversation_members(ConversationId),
    lists:flatten(lists:map(fun get_channels/1, Members)).

%% private
get_channels(UserId) ->
    gproc:lookup_pids({p, l, {channel, UserId}}).

%% private
is_online(UserId) ->
    [] =/= get_channels(UserId).
