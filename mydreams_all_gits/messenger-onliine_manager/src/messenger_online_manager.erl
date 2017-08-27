-module(messenger_online_manager).
-export([start_link/0
        ,subscribe/1
        ,notify_online/1
        ,notify_offline/1]).

-behaviour(gen_server).
-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3]).

-define(SERVER, ?MODULE).
-define(TAB_NAME, online_manager_subscribers).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, #{}, []).

subscribe(Members) ->
    Pid = self(),
    ets:insert(?TAB_NAME, [{UserId, Pid} || UserId <- Members]),
    gen_server:cast(?SERVER, {monitor, Pid}).

notify_online(UserId) ->
    notify(UserId, online).

notify_offline(UserId) ->
    notify(UserId, offline).

%% @private
notify(UserId, Status) ->
    Subscribers = ets:lookup(?TAB_NAME, UserId),
    lager:debug("Notify ~p User#~p is ~p", [Subscribers, UserId, Status]),
    lists:foreach(fun({_, Subscriber}) ->
        Subscriber ! {user_status, Status, UserId}
    end, Subscribers).

%% @private
init(#{}) ->
    beruang:get_ets(?TAB_NAME, [bag, public, named_table]),
    {ok, #{}}.

%% @private
handle_call(_Request, _From, State) ->
    {reply, {error, unknown_call}, State}.

%% @private
handle_cast({monitor, Pid}, State) ->
    _MRef = monitor(process, Pid),
    {noreply, State}.

%% @private
handle_info({'DOWN', _MRef, _Type, Pid, _Info}, State) ->
    lager:debug("~p cleanup", [?SERVER]),
    ets:match_delete(?TAB_NAME, {'_', Pid}),
    {noreply, State}.

%% @private
terminate(_Reason, _State) ->
    ok.

%% @private
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
