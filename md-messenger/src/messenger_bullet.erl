-module(messenger_bullet).

-export([init/4
        ,stream/3
        ,info/3
        ,terminate/2]).

-define(JWT_KEY, <<"super-secret-key">>).

init(_Transport, Req, _Opts, _Active) ->
    {Token, Req1} = cowboy_req:qs_val(<<"token">>, Req),
    lager:debug("Token: ~p", [Token]),
    {ok, #{<<"user_id">> := UserId}} = jwt:decode(Token, ?JWT_KEY),
    lager:debug("bullet init: ~p", [UserId]),
    messenger_channels:reg_channel(UserId),
    {ok, Req1, #{user_id => UserId}}.

stream(Data, Req, #{user_id := UserId} = State) ->
    lager:debug("stream#~p received: ~ts", [UserId, Data]),
    IncomingMessage = jsx:decode(Data, [return_maps]),
    messenger_protocol:handle(IncomingMessage, Req, State).

info({send_message, Message}, Req, State) ->
    lager:debug("Send message ~p", [Message]),
    OutgoingMessage = jsx:encode(#{
        type => im,
        command => message,
        payload => Message
    }),
    {reply, OutgoingMessage, Req, State};
info({comment, Comment}, Req, State) ->
    lager:debug("Post comment: ~p", [Comment]),
    OutgoingMessage = jsx:encode(#{
        type => comments,
        command => comment,
        payload => Comment
    }),
    {reply, OutgoingMessage, Req, State};
info(Info, Req, State) ->
    lager:error("Unexpected info ~p", [Info]),
    {ok, Req, State}.

terminate(_Req, #{user_id := UserId}) ->
    lager:debug("bullet terminate: ~p", [UserId]),
    ok.
