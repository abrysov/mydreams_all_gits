-module(messenger_comments).
-export([start_link/0
        ,subscribe/2
        ,notify/3]).

-behaviour(gen_server).
-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3]).

-define(SERVER, ?MODULE).
-define(TAB,      comments_subscribers).
-define(MONITORS, comments_subscribers_monitors).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, #{}, []).

subscribe(ResourceType, ResourceId) ->
    Pid = self(),
    ets:insert(?TAB, {{ResourceType, ResourceId}, Pid}),
    gen_server:cast(?SERVER, {monitor, Pid}).

notify(ResourceType, ResourceId, Comment) ->
    Subscribers = ets:lookup(?TAB, {ResourceType, ResourceId}),
    lists:foreach(fun({_Key, Subscriber}) ->
        Subscriber ! {comment, Comment}
    end, Subscribers).

init(_Args) ->
    beruang:get_ets(?TAB,      [bag, public, named_table]),
    beruang:get_ets(?MONITORS, [set, public, named_table]),
    self() ! monitor_at_init,
    {ok, #{}}.

handle_call(_Request, _From, State) ->
    {reply, {error, unknown_call}, State}.

handle_cast({monitor, Pid}, State) ->
    case ets:lookup(?MONITORS, Pid) of
        [] ->
            MRef = monitor(process, Pid),
            ets:insert(?MONITORS, {Pid, MRef});
        [{Pid, _MRef}] ->
            true
    end,
    {noreply, State}.

handle_info(monitor_at_init, State) ->
    ok = monitor_at_init(),
    {noreply, State};
handle_info({'DOWN', _MRef, _Type, Pid, _Info}, State) ->
    lager:debug("~p cleanup", [?SERVER]),
    ets:match_delete(?TAB, {'_', Pid}),
    ets:delete(?MONITORS, Pid),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

monitor_at_init() ->
    monitor_at_init_next(ets:first(?MONITORS)).
monitor_at_init_next('$end_of_table') ->
    ok;
monitor_at_init_next(Pid) ->
    MRef = monitor(process, Pid),
    ets:update_element(?MONITORS, Pid, {2, MRef}),
    monitor_at_init_next(ets:next(?MONITORS, Pid)).
