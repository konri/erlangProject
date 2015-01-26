%%%-------------------------------------------------------------------
%%% @author Konrad Hopek i Agnieszka Maksylewicz
%%% @doc

%%% Projekt wykorzystuje web server moduls, który umożliwia pobranie danych ze stron internetowych.
%%% Za pomocą pluginu mochiweb zczytujemy każdy interesujący nasz element za pomocą podania
%%% adresu URL strony, którą chcemy zparsować oraz scieżke do danego elementu tzw. XPATH.
%%% Dla przykładu kiedy chcemy pobrać informacje z jakieś strony np wszystkie elementy z div o id = temp
%%% wywołujemy funkcje getInformation(Dany Url, XPath) czyli: getInformation("strona.html", "//*[@id="temp"]ol/li").
%%% Dzięki temu wywołaniu dostajemy zwrotną informację binarną, która wystarczy odpowiednio obrobić do swoich potrzeb.

%%% @end
%%% Created : 02. sty 2015 11:43
%%%-------------------------------------------------------------------

-module(handleParser).
-author('Konrad Hopek').
-export([start/0,stop/0,getAllValuesConcurrency/1,removeEmptyElements/2,removeNonExistWebs/2]).

% start Web server modules
start() ->
    inets:start().

% stop Web server modules
stop() ->
    inets:stop().

% run Concurrency function which parse infromation from webs.
% also convert list to javascript
getAllValuesConcurrency(Url) ->
    Self = self(),
    Pids = [ spawn_link(fun() -> Self ! {self(), getAllValues(X)} end) || X <- Url ],
    Results = [ receive {Pid, R} -> R end || Pid <- Pids ],
    convertToJs(Results).

% remove all void element from list
removeEmptyElements(Lista, []) ->
    Lista;
removeEmptyElements(Lista, [H|T]) ->
    if
        H == void ->
            removeEmptyElements(Lista, T);
        true ->
            removeEmptyElements([H] ++ Lista, T)
    end.

% remove all non exist website from lists.
removeNonExistWebs(Lista, []) ->
    Lista;
removeNonExistWebs(Lista, [H|T]) ->
    L = chechIfExist(H),
    if
        L == true ->
            removeNonExistWebs([H] ++ Lista, T);
        L == false ->
            removeNonExistWebs(Lista, T)
    end.


% parsers functions:
getJsonStructure(Request) ->
    mochiweb_html:parse(response_body(Request)).

getSpecifyElements(HtmlTag, JsonStructure) ->
    mochiweb_xpath:execute(HtmlTag,JsonStructure).

getInformation(Url, HtmlTag) ->
    getSpecifyElements(HtmlTag, getJsonStructure(getResponse(Url))).

getResponse(Url) ->
    httpc:request(get, {Url,[]},[],[]).


getAllValues(Url) ->
    getDays(Url) ++ "=" ++ getTemps(Url) ++ "=" ++ getWinds(Url).

getDays(Url) ->
    String = getDayList(getInformation(Url,"//td[@id='day']")),
    String.
getTemps(Url) ->
    String = convertToList(getTemperatureList(getInformation(Url,"//td[@id='temp']"))),
    String.
getWinds(Url) ->
    String = getWindList(getInformation(Url,"//td[@id='wind']")),
    String.


% auxiliary functions:
lengthList([]) ->
    0;
lengthList([_|T]) ->
    1 + lengthList(T).

response_body({ok, { _, _, Body}}) ->
    Body.

convertToList([])->
    "";
convertToList([H|T]) ->
    L = lengthList(T),
    if
        L =:= 0 ->
            integer_to_list(H);
        true ->
            integer_to_list(H) ++ "," ++ convertToList(T)
    end.

convertToJs([]) ->
    "";
convertToJs([String|T]) ->
    L = lengthList(T),
    if
        L =:= 0 ->
            String;
        true ->
            String ++ "+" ++ convertToJs(T)
    end.

% check if website is still available.
chechIfExist(Url) ->
    List = getResponse(Url),
    {_,{{_,Get,_},_,_}} = List,
    if
        Get == 200 ->
            true;
        true ->
            false
    end.


% get Data from binary for name of days, temeperature and wind.
getDayList([]) ->
    "";
getDayList([H|T]) ->
    {_,_,C} = H,
    [BinaryString] = C,
    String = erlang:binary_to_list(BinaryString),
    L = lengthList(T),
    if
        L =:= 0 ->
            String;
        true ->
            String ++ "," ++ getDayList(T)
    end.

getTemperatureList([]) ->
    [];
getTemperatureList([H|T])->
    {_,_,C} = H,
    [BinaryInt] = C,
    Int = erlang:binary_to_integer(BinaryInt),
    [Int] ++ getTemperatureList(T).

getWindList([]) ->
    "";
getWindList([H|T]) ->
    {_,_,C} = H,
    [BinaryString] = C,
    String = erlang:binary_to_list(binary:part(BinaryString, {0, byte_size(BinaryString) - 5})),
    L = lengthList(T),
    if
        L =:= 0 ->
            String;
        true ->
            String ++ "," ++ getWindList(T)
    end.
