-module(owner).
-export([init_owner/1]).


work() ->
	receive
		{hello, PID} ->
		{bye, PID} -> 

	end.
