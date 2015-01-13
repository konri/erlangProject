%%%-------------------------------------------------------------------
%%% @author Konrad Hopek
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. sty 2015 22:21
%%%-------------------------------------------------------------------
-module(func).
-author("Konrad Hopek").

%% API
-compile(export_all).

fact(X) -> fact(X, 1).

fact(0, R) -> R;
fact(X, R) when X > 0 -> fact(X-1, R*X).

create_list(0) ->
  [];
create_list(N) ->
  [N] ++ create_list(N-1).

mnozenie(X) ->
  X*X.


calc(N) ->
  Url = [5,6,7],
  Self = self(),
  Pids = [ spawn_link(fun() -> Self ! {self(), create_list(X)} end) || X <- Url ],

  [ receive {Pid, R} -> R end || Pid <- Pids ].



funcget(cos)->
  {ok,"dsadsadsa"};
funcget(kos) ->
  undefined.

createlist(Pids) ->
[ case funcget(Pid) of
undefined -> "None";
{ok, Val} -> Val
end || Pid <-Pids ].




getList() ->
Lista = calc(5),
[A,B,C,D,E] = Lista,
C.
