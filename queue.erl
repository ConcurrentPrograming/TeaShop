-module(queue).
-export([order/0]).


order() ->
	receive
		{order, cust_pid} ->
			%%kunden beställer en till kopp!!!
	end.
