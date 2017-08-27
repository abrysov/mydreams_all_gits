-module(msn_embed_pool_sup).
-export([start_link/0]).

-behaviour(supervisor).
-export([init/1]).

-define(SERVER, ?MODULE).
-define(POOL_NAME, embed).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, {}).

init({}) ->
    PoolArgs = [
        {name, {local, ?POOL_NAME}},
        {worker_module, msn_embed_worker},
        {size, 10},
        {max_overflow, 20}
    ],
    WorkerArgs = [],
    ChildSpec = poolboy:child_spec(?POOL_NAME, PoolArgs, WorkerArgs),
    SupFlags = #{
        strategy  => one_for_one,
        intensity => 10,
        period    => 10
    },
    {ok, {SupFlags, [ChildSpec]}}.
