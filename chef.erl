-module(chef).
-export([work/0]).


work() ->
	receive
		{hello, PID} ->
			io:format("hej hej from chef");
		{bye, PID} -> 
			io:format("hej hej hej då från chef")
	end.
