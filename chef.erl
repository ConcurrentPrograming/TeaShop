-module(chef).
-export([init_chef/0]).


init_chef() ->
	work().

work() ->
	io:format("Chef started to work -n").
	%receive
	%	{hello, PID} ->
	%		io:format("hej hej from chef");
	%	{bye, PID} -> 
	%		io:format("hej hej hej då från chef")
	%end.
