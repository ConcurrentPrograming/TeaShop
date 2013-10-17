-module(owner).
-export([work/0]).


work() ->
	receive
		{hello, PID} ->
			io:format("hej hej from owner");
		{bye, PID} -> 
			io:format("hej hej hej då från owner")
	end.
