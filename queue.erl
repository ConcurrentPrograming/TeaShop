-module(orderqueue).
-export([init_orderqueue/0]).

init_orderqueue() ->
	List = [],
	order().

order() ->
	receive
		{order, PID} -> 	%%kunden beställer en till kopp!!!
			List = List | PID
	end.
