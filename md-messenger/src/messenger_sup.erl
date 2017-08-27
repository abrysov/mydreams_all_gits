%%%-------------------------------------------------------------------
%% @doc messenger top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(messenger_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_all, 5, 10}, [
      ?CHILD(messenger_cowboy_sup, supervisor),
      ?CHILD(messenger_comments, worker)
    ]} }.

%%====================================================================
%% Internal functions
%%====================================================================
