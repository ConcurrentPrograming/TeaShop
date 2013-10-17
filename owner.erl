-module(owner).
-export([init_owner/0]).


init_owner() ->
	work().

work() ->
	receive
		{hello, PID} ->
			io:format("hej hej from owner");
		{bye, PID} -> 
			io:format("hej hej hej då från owner")
	end.
