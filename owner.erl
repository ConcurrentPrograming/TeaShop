-module(owner).
-export([init_owner/0]).


init_owner() ->
	List = [],
	work().



work() ->
	receive
		{hello, PID} ->
			List = PID | List;
		{bye, PID} -> 
			io:format("hej hej hej då från owner")
	end.
