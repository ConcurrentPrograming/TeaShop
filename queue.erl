-module(queue).
-export([order/0]).


order() ->
	receive
		{done, cust_pid} -> ;
			%%kunden är klar o lämnar!!!
		{order, cust_pid} ->
			%%kunden beställer en till kopp!!!
	end.
