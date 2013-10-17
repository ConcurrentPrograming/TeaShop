-module(orderqueue).
-export([order/0]).


order() ->
	receive
		{order, PID} -> 	%%kunden beställer en till kopp!!!
			io:format("hej hej hej"+ PID)
	end.
