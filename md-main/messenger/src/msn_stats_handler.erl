-module(msn_stats_handler).

-export([init/3
        ,is_authorized/2
        ,content_types_provided/2]).

-export([to_text/2]).

-define(AUTH_TOKEN, <<"4d587d66367a1454d27e747b916ed1f0">>).

init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.

is_authorized(Req, State) ->
    {AuthToken, Req1} = cowboy_req:header(<<"auth-token">>, Req),
    case AuthToken of
        ?AUTH_TOKEN ->
            {true, Req1, State};
        _ ->
            {{false, <<"you shall not pass">>}, Req1, State}
    end.

content_types_provided(Req, State) ->
    {[
        {<<"text/plain">>, to_text}
    ], Req, State}.

to_text(Req, State) ->
    ChannelsCount = msn_channels:total_count(),
    Body = iolist_to_binary([
        <<"channels_count=">>,
        integer_to_list(ChannelsCount)
    ]),
    {Body, Req, State}.
