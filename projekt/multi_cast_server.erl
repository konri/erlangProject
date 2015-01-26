%%%-------------------------------------------------------------------
%%% @author Konrad Hopek
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. sty 2015 10:16
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
-module(multi_cast_server).

-behaviour(gen_server).
%% API
-export([start_link/0]).
-export([get_current_user_status/0,
  get_current_user_status/1,
  get_all_users/0,
  update_status/2]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).
-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================
get_current_user_status() ->
  gen_server:call(?MODULE, {get_current_user_status}).

get_current_user_status(User) ->
  gen_server:call(?MODULE, {get_current_user_status, User}).

get_all_users() ->
  gen_server:call(?MODULE, {get_users}).

update_status(User, Status) ->
  ok = gen_server:call(?MODULE, {update_status, User, Status}),
  ok.


%%%===================================================================
%%% Functions for internal Use zapis do bazy danych.
%%%===================================================================
update_user_status([], User, Status) ->
  [{User, Status}];
update_user_status([{User, OldStatus} | Tail], User, Status) ->
  [{User,Status ++ "=" ++ OldStatus} | Tail];

update_user_status([{O,S}|Tail], User, Status) ->
  R = update_user_status(Tail, User, Status),
  [{O,S}|R].
get_user_status(UserStatus, TargetUser) ->
  case lists:filter(fun({User,_Status}) ->
    User == TargetUser
  end,
    UserStatus) of
    [] ->
      no_status;
    [TargetUserStatus] ->
      {ok, TargetUserStatus}
  end.


get_users([]) ->
  [];
get_users([H|T])->
  {User, _Status} = H,
  [User] ++ get_users(T).


%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%% {ok, State, Timeout} |
%% ignore |
%% {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
  io:format("~n~p:~p(~p) init(~p)~n",
    [?MODULE, ?LINE, self(), []]),
  {ok, []};
init(Status) ->
  io:format("~n~p:~p(~p) init(~p)~n",
    [?MODULE, ?LINE, self(), Status]),
  {ok, Status}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages

%%
%% @spec handle_call(Request, From, State) ->
%% {reply, Reply, State} |
%% {reply, Reply, State, Timeout} |
%% {noreply, State} |

%% {stop, Reason, Reply, State} |
%% {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({get_current_user_status}, _From, State) ->
  {reply,
    {ok, State},
    State};

handle_call({get_users}, _From, State) ->
  {reply,
   get_users(State),
    State};


handle_call({get_current_user_status, User}, _From, State) ->
  {reply,
    get_user_status(State, User),
    State};
handle_call({update_status, User, Status}, _From, State) ->
  io:format("~p:~p (~p) Update ~p -> ~p ~n",
    [?MODULE, ?LINE, self(), User, Status]),
  io:format("STATE ~p ~n", [State]),
  NewState = update_user_status(State, User, Status),
  {reply, ok, NewState}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%% {noreply, State, Timeout} |
%% {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
  {noreply, State}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%% {noreply, State, Timeout} |
%% {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
  {noreply, State}.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
  ok.
%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
%%%===================================================================
%%% Internal functions
%%%===================================================================
