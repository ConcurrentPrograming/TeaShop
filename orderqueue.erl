-module(orderqueue).
-export([init_orderqueue/0]).

init_orderqueue() ->
	List = [],
	order(List).

order(List) ->
	io:format("orderqueue:order(List) (~p) where List=~w~n", [self(),List]).
	%receive
	%	{order, PID} -> 	%%kunden beställer en till kopp!!!
	%		List = [List | PID],
	%		order(List)
	%end.
