%%% ========================================================== [ elli_json.erl ]
%%% @doc elli_json middleware.
%%% Encode the response body as JSON.
%%%
%%% @author Sukumar Yethadka
%%% @copyright 2016, Sukumar Yethadka; 2017-2018, elli-lib team.
%%% @end
%%% ==================================================================== [ EOH ]
-module(elli_json).

%% Elli Middleware.
-export([postprocess/3]).


%%% ======================================================== [ Elli Middleware ]

-spec postprocess(Req, Res1, Config) -> Res2 when
      Req    :: elli:req(),
      Res1   :: elli_handler:result(),
      Config :: elli_handler:callback_args(),
      Res2   :: elli_handler:result().
%% Do not convert to JSON when response has no headers
postprocess(_Req, {ResponseCode, Body}, _Config) ->
    {ResponseCode, Body};
postprocess(_Req, {ResponseCode, Headers, Body} = Res, _Config)
  when is_integer(ResponseCode) orelse ResponseCode =:= ok ->
    case should_convert(Headers, Body) of
        false ->
            Res;
        true ->
            {ResponseCode, Headers, jiffy:encode(Body)}
    end;
postprocess(_, Res, _) ->
    Res.


%%% ================================================================ [ Helpers ]

should_convert(Headers, Body) ->
    case proplists:get_value(<<"Content-Type">>, Headers) of
        <<"application/json">> ->
            not is_binary(Body);
        _ ->
            false
    end.


%%% ==================================================================== [ EOF ]
