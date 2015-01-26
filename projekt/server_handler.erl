%%%-------------------------------------------------------------------
%%% @author Konrad Hopek
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. sty 2015 21:24
%%%-------------------------------------------------------------------
-module(server_handler).
-behaviour(gen_server).
-author("Konrad Hopek").

%% API
-export([start_link/0]).
-export([get_id/0]).
%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).
-record(state, {count}).

get_id() ->
  {id, ID} = gen_server:call(?MODULE, {}),
  ID.
%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
init([]) ->
  {ok, #state{count= 1 }}.

%% The OTP wraps msg in a structure that enables the gen_server which call to handle_cast and handle call for different kinds of msgs.
handle_call(_Request, _From, State) ->
  Count = State#state.count,
  {reply,
    {id, Count},
    #state{count = Count + 1}}.
handle_cast(_Msg, State) ->
  {noreply, State}.

%% if a msg is sent to the server that is not wrapped -> will be handled by handle_info.
handle_info(_Info, State) ->
  {noreply, State}.
terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.