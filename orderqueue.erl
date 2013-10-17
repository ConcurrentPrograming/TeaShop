-module(orderqueue).
-export([order/0]).


order() ->
	receive
		{order, cust_pid} -> 	%%kunden beställer en till kopp!!!
			io:format("hej hej hej")
	end.
