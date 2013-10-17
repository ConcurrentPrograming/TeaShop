-module(owner).
-export([init_owner/0]).


init_owner() ->
	List = [],
	work(List).



work(List) ->
	receive
		{hello, PID} ->
			List = [PID | List],
			work(List);
		{bye, PID} -> 
			io:format("hej hej hej då från owner"),   %%%  ta bort pid ur lista!!!
			work(List)
	end.
