-module(msn_comment_resource).

-export([new/1
        ,start_link/1
        ,add_listener/2
        ,remove_listener/2
        ,notify_listeners/2]).

-behaviour(gen_server).
-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3]).

-record(state, {
    channels = sets:new()
}).

new(Id) ->
    case gproc:where({n, l, {resource, Id}}) of
        undefined ->
            {ok, NewPid} = msn_comment_resources_sup:start_resource(Id),
            NewPid;
        ExistingPid ->
            ExistingPid
    end.

start_link(Id) ->
    gen_server:start_link(?MODULE, Id, []).

init(Id) ->
    gproc:reg({n, l, {resource, Id}}),
    {ok, #state{}}.

add_listener(Pid, Listner) ->
    gen_server:call(Pid, {add_listener, Listner}).

remove_listener(Pid, Listner) ->
    gen_server:call(Pid, {remove_listener, Listner}).

notify_listeners(Pid, Event) ->
    gen_server:call(Pid, {notify_listeners, Event}).

handle_call({add_listener, Listner}, _From, #state{channels = Channels0} = State) ->
    Channels = sets:add_element(Listner, Channels0),
    {reply, ok, State#state{channels = Channels}};
handle_call({remove_listener, Listner}, _From, #state{channels = Channels0} = State) ->
    Channels = sets:del_element(Listner, Channels0),
    {reply, ok, State#state{channels = Channels}};
handle_call({notify_listeners, Event}, _From, #state{channels = Channels0} = State) ->
    lager:debug("notify_listeners: Channels0: ~p", [Channels0]),
    Channels = sets:filter(fun(Pid) ->
        case is_process_alive(Pid) of
            true ->
                Pid ! Event,
                true;
            false ->
                false
        end
    end, Channels0),
    {reply, ok, State#state{channels = Channels}};
handle_call(_Request, _From, State) ->
    {reply, {error, unknown_call}, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
