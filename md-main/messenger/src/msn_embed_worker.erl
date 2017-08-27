-module(msn_embed_worker).
-export([process_message/1]).

-behaviour(poolboy_worker).
-export([start_link/1]).

-behaviour(gen_server).
-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3]).

-define(POOL_NAME, embed).

start_link(_) ->
    gen_server:start_link(?MODULE, {}, []).

process_message(Message) ->
    lager:debug("~s:process_message(~p)", [?MODULE, Message]),
    Worker = poolboy:checkout(?POOL_NAME),
    lager:debug("poolboy:checkout(~p) => ~p", [?POOL_NAME, Worker]),
    gen_server:cast(Worker, {message, Message}).

init({}) ->
    {ok, undefined}.

handle_call(_Request, _From, State) ->
    {reply, {error, unknown_call}, State}.

handle_cast({message, Message}, State) ->
    ok = message(Message),
    ok = poolboy:checkin(?POOL_NAME, self()),
    lager:debug("poolboy:checkin(~p, ~p)", [?POOL_NAME, self()]),
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

message(#{<<"message">> := Text} = Message) ->
    case msn_embed:extract_urls(Text) of
        []      -> ok;
        [Url|_] ->
            lager:debug("~s:message(~s, Message)", [?MODULE, Url]),
            url(Url, Message)
    end.

url(Url, #{<<"conversation_id">> := ConversationId} = Message) ->
    case msn_embed:fetch(Url) of
        request_failed -> ok;
        unsupported    -> ok;
        undefined      -> ok;
        Attachment when is_map(Attachment) ->
            Reply = #{
                previous_message => Message,
                conversation_id  => ConversationId,
                attachments      => [Attachment],
                hidden           => true
            },
            msn_channels:bcast_message({send_message, Reply}, ConversationId)
    end.
