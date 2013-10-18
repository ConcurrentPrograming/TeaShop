-module(owner).
-export([init_owner/0]).


init_owner() ->
	io:format("owner will be initiated or how it's spelled..."),
	List = [],
	work(List).



work(List) ->
	io:format("hej hej från owner....").
	%receive
	%	{hello, PID} ->
	%		List = [PID | List],
	%		work(List);
	%	{bye, PID} -> 
	%		io:format("hej hej hej då från owner"),   %%%  ta bort pid ur lista!!!
	%		work(List)
	%end.
