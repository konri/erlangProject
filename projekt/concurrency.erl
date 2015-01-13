%%%-------------------------------------------------------------------
%%% @author Konrad Hopek
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. sty 2015 19:15
%%%-------------------------------------------------------------------
-module(concurrency).
-author("Konrad Hopek").

%% API
-compile(export_all).

test() ->
  receive
    {From, do_a_flip} ->
      From ! "How about no?",
      test();
    {From, fish} ->
      From ! "Nara!";
    _ ->
      io:format("default"),
      test()

  end.

start()->
  Dolphin = spawn(concurrency,test,[]),
    Dolphin ! {self(), do_a_flip}.


concurent(Pid,Liczba) ->
  Nowa_liczba = Liczba*Liczba,
  io:format("~p~n", [Nowa_liczba]),
  Pid ! {self(),Nowa_liczba}.

start() ->
  Pid1 = spawn(?MODULE, concurent, [self(),5]),
  Pid2 = spawn(?MODULE, concurent, [self(),6]),
  Pid3 = spawn(?MODULE, concurent, [self(),7]).

getConcurent(Liczba) ->
  receive
    {From, LiczbaTmp} ->
      getConcurent(Liczba);
    _ ->

  end