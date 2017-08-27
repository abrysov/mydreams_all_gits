-module(messenger_cowboy_sup).
-export([start_link/0]).

-behaviour(supervisor_bridge).
-export([init/1
        ,terminate/2
]).

-record (state, {}).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor_bridge:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", cowboy_static, {priv_file, messenger, "index.html"}},
            {"/static/[...]", cowboy_static, {priv_dir, messenger, "static"}},
            {"/bullet/static/[...]", cowboy_static, {priv_dir, bullet, []}},
            {"/bullet", bullet_handler, [{handler, messenger_bullet}]}
        ]}
    ]),
    {ok, Pid} = cowboy:start_http(http, 100, [{port, 8080}], [
      {env, [{dispatch, Dispatch}]}
    ]),
    {ok, Pid, #state{}}.

terminate(_Reason, _State) ->
    ok.
