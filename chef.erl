-module(chef).
-export([init_chef/0]).


init_chef() ->
	io:format("chef is initiated ~p~n", [self()]),
	work().

work() ->
	%io:format("Chef is working ~n"),
	receive
		{serve, Customer} ->
			io:format("Chef is serving a cup of tea to customer ~p~n",[Customer]),
			Customer ! cup;
		list_not_ ->
			main:getOrderList() ! {checkorder, self()}
	end.
