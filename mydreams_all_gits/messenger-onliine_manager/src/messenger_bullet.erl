-module(messenger_bullet).

-export([init/4
        ,stream/3
        ,info/3
        ,terminate/2]).

-record(state, {user_id}).

-define(JWT_KEY, <<"super-secret-key">>).

init(_Transport, Req, _Opts, _Active) ->
    {Token, Req1} = cowboy_req:qs_val(<<"token">>, Req),
    lager:debug("Token: ~p", [Token]),
    {ok, #{<<"user_id">> := UserId}} = jwt:decode(Token, ?JWT_KEY),
    lager:debug("bullet init: ~p", [UserId]),
    messenger_channels:reg_channel(UserId),
    {ok, Req1, #state{user_id = UserId}}.

stream(Data, Req, State=#state{user_id = UserId}) ->
    lager:debug("stream#~p received: ~ts", [UserId, Data]),
    IncomingMessage = jsx:decode(Data, [return_maps]),
    Type = maps:get(<<"type">>, IncomingMessage, undefined),
    case Type of
        <<"ping">> ->
            Reply = jsx:encode(#{type => pong}),
            {reply, Reply, Req, State};
        <<"last_messages">> ->
            %% TODO: restrict access
            ConversationId = maps:get(<<"conversation_id">>, IncomingMessage),
            OutgoingMessage = jsx:encode(#{
                type => last_messages,
                messages => load_last_messages(ConversationId)
            }),
            {reply, OutgoingMessage, Req, State};
        <<"online_list">> ->
            %% TODO: restrict access
            ConversationId = maps:get(<<"conversation_id">>, IncomingMessage),
            OutgoingMessage = jsx:encode(#{
                type => online_list,
                online_list => online_list(ConversationId)
            }),
            lager:debug("online_list reply ~ts", [OutgoingMessage]),
            {reply, OutgoingMessage, Req, State};
        <<"message">> ->
            %% TODO: restrict access
            ok = on_message(UserId, IncomingMessage),
            {ok, Req, State};
        <<"mark_read">> ->
            %% TODO: restrict access
            ok = mark_read(UserId, IncomingMessage),
            {ok, Req, State};
        _ ->
            lager:error("Unkown type: ~ts", [Type]),
            {ok, Req, State}
    end.

info({send_message, Message}, Req, State) ->
    lager:debug("send_message ~p", [Message]),
    OutgoingMessage = jsx:encode(#{
        type => message,
        message => Message
    }),
    {reply, OutgoingMessage, Req, State};
info({user_status, Status, UserId}, Req, State) ->
    OutgoingMessage = jsx:encode(#{
        type => user_status,
        status => Status,
        user_id => UserId
    }),
    {reply, OutgoingMessage, Req, State};
info(Info, Req, State) ->
    lager:error("Unexpected info ~p", [Info]),
    {ok, Req, State}.

terminate(_Req, #state{user_id = UserId}) ->
    lager:debug("bullet terminate: ~p", [UserId]),
    ok.

%% private
load_last_messages(ConversationId) ->
    messenger_persistence:last_messages(ConversationId, 10).

%% private
on_message(UserId, IncomingMessage) ->
    Text = maps:get(<<"text">>, IncomingMessage),
    ConversationId = maps:get(<<"conversation_id">>, IncomingMessage),
    messenger_channels:send_message(UserId, ConversationId, Text).

%% private
online_list(ConversationId) ->
    messenger_channels:online_list(ConversationId).

%% private
mark_read(UserId, IncomingMessage) ->
    MessageId = maps:get(<<"message_id">>, IncomingMessage),
    {ok, _} = messenger_persistence:mark_read(UserId, MessageId),
    ok.
