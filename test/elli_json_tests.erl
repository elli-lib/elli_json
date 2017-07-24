%%% ==================================================== [ elli_json_tests.erl ]
%%% @doc elli_json tests.
%%% @end
%%% ==================================================================== [ EOH ]
-module(elli_json_tests).

-include_lib("eunit/include/eunit.hrl").


%%% ============================================================= [ Unit Tests ]

postprocess_test() ->
    %% Empty headers
    check({200, body()}, {200, body()}),

    %% Already encoded
    check({200, headers(), json_body()},
          {200, headers(), json_body()}),

    %% Encode body
    check({200, headers(), json_body()},
          {200, headers(), body()}).


%%% ================================================================ [ Helpers ]

check(Expected, Res) ->
    ?assertEqual(Expected, elli_json:postprocess(req(), Res, [])).


body() ->
    {[{foo,[<<"bing">>,2.3,true]}]}.


json_body() ->
    <<"{\"foo\":[\"bing\",2.3,true]}">>.


headers() ->
    [{<<"Content-Type">>, <<"application/json">>}].


req() ->
    elli_http:mk_req('GET', {abs_path, <<"/">>},
                     [{<<"Accept">>, <<"application/json">>}],
                     <<>>, {1, 1}, undefined, {elli_json, []}).


%%% ==================================================================== [ EOF ]
