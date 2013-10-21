-module(chef).
-export([init_chef/0]).


init_chef() ->
	io:format("Process ~w at ~w: Chef is initiated~n", [self(), clock:get_time()]),
	work().

work() ->
	%io:format("Chef is working ~n"),
	receive
		{serve, Customer} ->
			io:format("Process ~w at ~w: Chef is serving a cup of tea to customer ~p~n",[self(), clock:get_time(),Customer]),
			Customer ! cup,
			work();
		list_not_empty ->
			main:getOrderList() ! {checkorder, self()},
			work();
		close -> 
			io:format("Process ~w at ~w: Chef is leaving ~n",[self(), clock:get_time()])
	end.
