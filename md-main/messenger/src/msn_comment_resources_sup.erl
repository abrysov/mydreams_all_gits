-module(msn_comment_resources_sup).

-export([start_link/0
        ,start_resource/1]).

-behaviour(supervisor).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, {}).

start_resource(Id) ->
    supervisor:start_child(?SERVER, [Id]).

init(_Args) ->
    SupFlags = #{
        strategy  => simple_one_for_one,
        intensity => 5,
        period    => 10
    },
    ChildSpec = #{
        id       => msn_comment_resources,
        start    => {msn_comment_resource, start_link, []},
        restart  => temporary,
        shutdown => 5000,
        type     => worker,
        modules  => [msn_comment_resource]
    },
    {ok, {SupFlags, [ChildSpec]}}.
