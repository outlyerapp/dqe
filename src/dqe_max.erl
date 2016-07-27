-module(dqe_max).
-behaviour(dqe_fun).

-include_lib("mmath/include/mmath.hrl").

-export([spec/0, describe/1, init/1, chunk/1, resolution/2, run/2]).

-record(state, {
          time :: pos_integer(),
          count :: pos_integer()
         }).

init([Time]) when is_integer(Time) ->
    #state{time = Time}.

chunk(#state{time = Time}) ->
    Time * ?RDATA_SIZE.

resolution(Resolution, State = #state{time = Time}) ->
    Res = dqe_time:apply_times(Time, Resolution),
    {Res, State#state{count = Res}}.

describe(#state{time = Time}) ->
    ["max(", integer_to_list(Time), "ms)"].

spec() ->
    {<<"max">>, [metric, integer], none, metric}.

run([Data], S = #state{count = Count}) ->
    {mmath_aggr:max(Data, Count), S}.