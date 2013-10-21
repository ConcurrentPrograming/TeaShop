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
			Customer ! cup,
			work();
		list_not_empty ->
			main:getOrderList() ! {checkorder, self()},
			work();
		close -> 
			io:format("Chef is leaving ~n")
	end.
