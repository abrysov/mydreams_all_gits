%%%-------------------------------------------------------------------
%% @doc messenger top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(msn_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-define(CHILD(I, Type), #{
    id       => I,
    start    => {I, start_link, []},
    restart  => permanent,
    shutdown => 5000,
    type     => Type,
    modules  => [I]
}).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

init([]) ->
    SupFlags = #{
      strategy => one_for_all,
      intensity => 5,
      period => 10
    },
    Children = [
      ?CHILD(msn_cowboy_sup, supervisor),
      ?CHILD(msn_comment_resources_sup, supervisor),
      ?CHILD(msn_embed_pool_sup, supervisor),
      ?CHILD(msn_comments, worker)
    ],
    {ok, {SupFlags, Children} }.
