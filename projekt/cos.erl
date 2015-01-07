-module(cos).
-compile(export_all).

start() ->
inets:start().
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


getTempInteger([],Lista) ->
    Lista;
getTempInteger([H|T],Lista)->
    {_,_,C} = H,
    [BinaryInt] = C,
    Int = erlang:binary_to_integer(BinaryInt),
    getTempInteger(T,Lista ++ [Int]).





