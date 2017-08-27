-module(msn_embed).

-export([extract_urls/1
        ,fetch/1]).

-define(URL_REGEXP, "https?\\:\\/\\/\\S+").
-define(HTTP_REQ_TIMEOUT, 15000000). %% 15 seconds
-define(META_TAGS, #{
    title        => ["headline", "og:title", "twitter:title"],
    description  => ["description", "og:description", "twitter:description"],
    service_name => ["og:site_name"],
    thumb_url    => ["og:image", "twitter:image:src"]
}).

extract_urls(Text) ->
    case re:run(Text, ?URL_REGEXP, [unicode, global, {capture, all, list}]) of
        {match, Results} ->
            [Url || [Url] <- Results];
        nomatch ->
            []
    end.

fetch(Url) ->
    case http_request(Url) of
        {ok, Result} ->
            process_http_result(Url, Result);
        {error, Reason} ->
            lager:info("Could not fetch ~p: ~p", [Url, Reason]),
            request_failed
    end.

http_request(Url) ->
    http_request(Url, []).

http_request(Url, Headers) ->
    Request = {Url, Headers},
    HTTPOptions = [{timeout, ?HTTP_REQ_TIMEOUT}],
    Options = [{body_format, binary}],
    httpc:request(get, Request, HTTPOptions, Options).

process_http_result(Url, {{_, 200, _}, Headers, Body}) ->
    ContentType = proplists:get_value("content-type", Headers),
    case {is_html(ContentType), is_image(ContentType)} of
        {true, _} ->
            process_html(Url, Body);
        {_, true} ->
            process_image(Url, Body);
        {false, false} ->
            unsupported
    end;
process_http_result(Url, {StatusLine, _Headers, _Body}) ->
    lager:info("HTTP Error while fetching ~p: ~p", [Url, StatusLine]),
    request_failed.

is_html(MimeType) ->
    is_match(MimeType, "^text/html").

is_image(MimeType) ->
    is_match(MimeType, "^image/\\w+").

is_match(String, Re) ->
    case re:run(String, Re, [unicode, {capture, none}]) of
        match   -> true;
        nomatch -> false
    end.

process_html(Url, Body) ->
    Html = mochiweb_html:parse(Body),
    MetaTagProperties = maps:filter(fun found/2, maps:map(fun(_, V) ->
        first_found_meta_tag(V, Html)
    end, ?META_TAGS)),
    if
        map_size(MetaTagProperties) > 0 ->
            MetaTagProperties#{from_url => list_to_binary(Url)};
        true ->
            undefined
    end.

found(_, not_found) -> false;
found(_, _)         -> true.

first_found_meta_tag([], _) -> not_found;
first_found_meta_tag([TagName|Rest], Html) ->
    case extract_meta_tag(TagName, Html) of
        [] ->
            first_found_meta_tag(Rest, Html);
        [Conent|_] ->
            Conent
    end.

extract_meta_tag(TagName, Html) ->
    XPath = binary_to_list(iolist_to_binary(
        ["//head/meta[@property=\"", TagName, "\"]/@content"])),
    mochiweb_xpath:execute(XPath, Html).

process_image(Url, Body) ->
    #{
        image_url => Url,
        image_bytes => size(Body)
    }.
