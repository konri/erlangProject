-module(cos).
-compile(export_all).

start() ->
    inets:start().

stop() ->
    inets:stop().

lengthList([]) ->
    0;
lengthList([_|T]) ->
    1 + lengthList(T).


post(URL, ContentType, Body) -> request(post, {URL, [], ContentType, Body}).
get(URL)                     -> request(get,  {URL, []}).

request(Method, Body) ->
    httpc:request(Method, Body, [], []).

 response_body({ok, { _, _, Body}}) -> Body.

%% to do: remove done function
done()->
Response =  httpc:request(get, {"http://localhost:8081/test.html",[]},[],[]),
Html_structure = response_body(Response),
Json_structure = mochiweb_html:parse(Html_structure),
Temperatures = mochiweb_xpath:execute("//td[@id='temp']",Json_structure),
Temperatures.


getResponse(Url) ->
    httpc:request(get, {Url,[]},[],[]).

getJsonStructure(Request) ->
    mochiweb_html:parse(response_body(Request)).

getSpecifyElements(HtmlTag, JsonStructure) ->
    mochiweb_xpath:execute(HtmlTag,JsonStructure).

getInformation(Url, HtmlTag) ->
    getSpecifyElements(HtmlTag, getJsonStructure(getResponse(Url))).







getTemperatureList([]) ->
    [];
getTemperatureList([H|T])->
    {_,_,C} = H,
    [BinaryInt] = C,
    Int = erlang:binary_to_integer(BinaryInt),
    [Int] ++ getTemperatureList(T).

getDayList([]) ->
    "";
getDayList([H|T]) ->
    {_,_,C} = H,
    [BinaryString] = C,
    String = erlang:binary_to_list(BinaryString),
%    String ++ "," ++ getDayList(T),
    L = lengthList(T),
    if
        L =:= 0 ->
            String;
        true ->
            String ++ "," ++ getDayList(T)
    end.

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

convertList([])->
    "";
convertList([H|T]) ->
    L = lengthList(T),
    if
        L =:= 0 ->
            integer_to_list(H);
        true ->
            integer_to_list(H) ++ "," ++ convertList(T)
    end.



test() ->
    Lista = [1,2,3,-4,45,85,-16],
    String = convertList(Lista),
    String.


getDays(Url) ->
    String = getDayList(getInformation(Url,"//td[@id='day']")),
    String.
getTemps(Url) ->
    String = convertList(getTemperatureList(getInformation(Url,"//td[@id='temp']"))),
    String.
getWinds(Url) ->
    String = getWindList(getInformation(Url,"//td[@id='wind']")),
    String.

getAllValues(Url) ->
    getDays(Url) ++ "=" ++ getTemps(Url) ++ "=" ++ getWinds(Url).

calc(Url) ->
    Self = self(),
    Pids = [ spawn_link(fun() -> Self ! {self(), getAllValues(X)} end) || X <- Url ],
    Results = [ receive {Pid, R} -> R end || Pid <- Pids ],
    convertToJs(Results).

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

