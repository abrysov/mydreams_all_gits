-module(msn_feedback_handler).

%% Standard callbacks.
-export([init/3
        ,allowed_methods/2
        ,content_types_accepted/2
        ,content_types_provided/2]).

%% Custom callbacks.
-export([deliver_feedback/2]).

init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.

content_types_accepted(Req, State) ->
    {[
        {<<"application/x-www-form-urlencoded">>, deliver_feedback},
        {<<"application/json">>, deliver_feedback},
        {<<"text/json">>, deliver_feedback}
    ], Req, State}.

content_types_provided(Req, State) ->
    {[
        {<<"application/json">>, to_json}
    ], Req, State}.


allowed_methods(Req, State) ->
    {[
        <<"POST">>
    ], Req, State}.

deliver_feedback(Req0, State) ->
    {Id, Req1} = cowboy_req:binding(id, Req0),
    lager:debug("deliver_feedback #[~p]", [Id]),
    case msn_persistence:feedback(Id) of
        #{<<"dreamer_id">> := DreamerId} = Feedback ->
            ok = msn_channels:send_to_user({feedback, Feedback}, DreamerId),
            {true, Req1, State};
        _ ->
            {false, Req1, State}
    end.
