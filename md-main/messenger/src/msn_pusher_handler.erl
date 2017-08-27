-module(msn_pusher_handler).

-export([init/3
        ,handle/2
        ,terminate/3]).

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req0, State) ->
    lager:debug("~p:handle/2", [?MODULE]),
    case cowboy_req:method(Req0) of
        {<<"POST">>, Req1} ->
            push(Req1, State);
        {_, Req1} ->
            method_not_allowed(Req1, State)
    end.

terminate(_Reason, _Req, _State) ->
    ok.

push(Req0, State) ->
    lager:debug("~p:push/2", [?MODULE]),
    {UserId, Req1} = cowboy_req:binding(user_id, Req0),
    {ok, Body, Req2} = cowboy_req:body(Req1),
    Message = prepare_message(Body),
    ok = msn_channels:send_to_user({pusher, Message}, UserId),
    {ok, Req3} = cowboy_req:reply(204, Req2),
    {ok, Req3, State}.

method_not_allowed(Req0, State) ->
    lager:debug("~p:method_not_allowed/2", [?MODULE]),
    {ok, Req1} = cowboy_req:reply(405, Req0),
    {ok, Req1, State}.

prepare_message(Message) ->
    Message.
