-module(barrel_httpd_futon).

-export([handle_req/1]).

handle_req(#httpd{method='GET'}=Req) ->
    Root = filename:join(code:priv_dir(barrel_futon), "www"),
    case filelib:is_dir(Root) of
        true ->

            "/" ++ UrlPath = couch_httpd:path(Req),
            case couch_httpd:partition(UrlPath) of
                {_ActionKey, "/", RelativePath} ->
                    % GET /_utils/path or GET /_utils/
                    CachingHeaders = [{"Cache-Control", "private, must-revalidate"}],
                    couch_httpd:serve_file(Req, RelativePath, Root, CachingHeaders);
                {_ActionKey, "", _RelativePath} ->
                    % GET /_utils
                    RedirectPath = couch_httpd:path(Req) ++ "/", couch_httpd:send_redirect(Req, RedirectPath),
                    couch_httpd:send_redirect(Req, RedirectPath)
            end;
        false ->
            couch_httpd:send_error(Req, not_found)
    end;
handle_req(Req, _) ->
    send_method_not_allowed(Req, "GET,HEAD").
