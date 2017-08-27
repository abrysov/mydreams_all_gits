-module(msn_comments).
-export([start_link/0
        ,subscribe/1
        ,unsubscribe/1
        ,notify/2]).

-behaviour(gen_server).
-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, {}, []).

subscribe(Resource) ->
    Pid = self(),
    gen_server:call(?SERVER, {subscribe, Resource, Pid}).

unsubscribe(Resource) ->
    Pid = self(),
    gen_server:call(?SERVER, {unsubscribe, Resource, Pid}).

notify(Resource, Event) ->
    gen_server:call(?SERVER, {notify, Resource, Event}).

init(_Args) ->
    {ok, #state{}}.

handle_call({subscribe, Resource, ListenerPid}, _From, State) ->
    ResourcePid = msn_comment_resource:new(Resource),
    ok = msn_comment_resource:add_listener(ResourcePid, ListenerPid),
    {reply, ok, State};
handle_call({unsubscribe, Resource, ListenerPid}, _From, State) ->
    ResourcePid = msn_comment_resource:new(Resource),
    ok = msn_comment_resource:remove_listener(ResourcePid, ListenerPid),
    {reply, ok, State};
handle_call({notify, Resource, Event}, _From, State) ->
    ResourcePid = msn_comment_resource:new(Resource),
    ok = msn_comment_resource:notify_listeners(ResourcePid, Event),
    {reply, ok, State};
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
