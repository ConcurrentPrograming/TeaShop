-module(chef).
-export([init_chef/0]).


init_chef() ->
	io:format("chef is initiated ~p~n", [self()]),
	work().

work() ->
	io:format("Chef is working ~n").
	%receive
	%	{hello, PID} ->
	%		io:format("hej hej from chef");
	%	{bye, PID} -> 
	%		io:format("hej hej hej då från chef")
	%end.
