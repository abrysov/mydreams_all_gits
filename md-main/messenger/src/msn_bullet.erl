-module(msn_bullet).

-export([init/4
        ,stream/3
        ,info/3
        ,terminate/2]).

-define(JWT_KEY, <<"super-secret-key">>).
-define(OFFLINE_STATUS_DELAY, 300000). %% 5 minutes

init(_Transport, Req, _Opts, _Active) ->
    {Token, Req1} = cowboy_req:qs_val(<<"token">>, Req),
    lager:debug("Token: ~p", [Token]),
    {ok, #{<<"user_id">> := UserId}} = jwt:decode(Token, ?JWT_KEY),
    lager:debug("bullet init: ~p", [UserId]),
    Props = extract_props(Req),
    msn_channels:reg_channel(UserId, Props),
    msn_persistence:set_online(UserId),
    {ok, Req1, #{user_id => UserId}}.

stream(Data, Req, #{user_id := UserId} = State) ->
    lager:debug("stream#~p received: ~ts", [UserId, Data]),
    IncomingMessage = jsx:decode(Data, [return_maps]),
    msn_protocol:handle(IncomingMessage, Req, State).

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
info({add_reaction, #{
    <<"reactable_type">> := ReactableType
} = Reaction}, Req, State) when ReactableType =:= <<"Comment">> ->
    OutgoingMessage = jsx:encode(#{
        type => comments,
        command => add_reaction,
        payload => Reaction
    }),
    {reply, OutgoingMessage, Req, State};
%% TODO: Nuke feedbacks
info({feedback, Feedback}, Req, State) ->
    OutgoingMessage = jsx:encode(#{
        type => feedback,
        command => create,
        payload => Feedback
    }),
    {reply, OutgoingMessage, Req, State};
info({pusher, Message}, Req, State) ->
    OutgoingMessage = jsx:encode(#{
        type => pusher,
        command => push,
        payload => Message
    }),
    {reply, OutgoingMessage, Req, State};
info(Info, Req, State) ->
    lager:error("Unexpected info ~p", [Info]),
    {ok, Req, State}.

terminate(_Req, #{user_id := UserId}) ->
    SelfPid = self(),
    OnlineStatus = case msn_channels:get_channels(UserId) of
        [SelfPid] ->
            set_offline_deferred(UserId),
            offline;
        _ ->
            %% User has other connections. Do nothing
            online
    end,
    lager:debug("bullet terminate: ~p", [UserId]),
    lager:debug("Online status: ~p", [OnlineStatus]),
    ok.

set_offline_deferred(UserId) ->
    {ok, _TRef} = timer:apply_after(?OFFLINE_STATUS_DELAY,
        msn_persistence, set_offline, [UserId]).

extract_props(Req) ->
    {{ClientIp, _Port}, _} = cowboy_req:peer(Req),
    {UserAgent,         _} = cowboy_req:header(<<"user-agent">>, Req),
    #{
        client_ip  => list_to_binary(inet_parse:ntoa(ClientIp)),
        user_agent => UserAgent
    }.
