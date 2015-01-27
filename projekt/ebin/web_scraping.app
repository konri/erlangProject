{
  application,
  web_scraping,
  [
    {description, "Web scraping for PWIR project"},
    {vsn, "1.0.0"},
    {modules,
      [
        web_scraping_app,
        web_scraping_sup,
        web_scraping_server,
        handleParser,
        mochijson2,
        mochiutf8,
        mochiweb_charref,
        mochiweb_html,
        mochiweb_xpath,
        mochiweb_xpath_functions,
        mochiweb_xpath_parser,
        mochiweb_xpath_utils,
        rfc4627
      ]},
    {registered, [web_scraping_server, web_scraping_sup]},
    {mod, {web_scraping_app, []}}
  ]
}.