-module(chef).
-export([init_chef/0]).


init_chef() ->
	io:format("chef is initiated ~p~n", [self()]),
	work().

work() ->
	io:format("Chef is working ~n"),
	receive
		{serve, Customer} ->
			Customer ! cup;
		listNotEmpty ->
			main:getOrderList() ! {checkorder, self()}
	end.
