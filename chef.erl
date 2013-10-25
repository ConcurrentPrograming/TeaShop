-module(chef).
-export([init_chef/0]).


init_chef() ->
	io:format("Process ~w at ~w: Chef is initiated~n", [self(), clock:get_time()]),
	main:getOwner() ! {hello, self(), 0},
	main:getOrderList() ! {add_worker, self()},
	work().

work() ->
	%io:format("Chef is working ~n"),
	receive
		%%{serve, Customer} ->
			%%io:format("Process ~w at ~w: Chef is serving a cup of tea to customer ~p~n",[self(), clock:get_time(),Customer]),
			%%Customer ! cup,
		%%	work();
		list_not_empty ->
			main:getOrderList() ! {checkorder, self()},
			receive
				{serve, CPID, Ref} ->
					io:format("Process ~w at ~w: Chef is serving a cup of tea (~p) to customer ~p~n",[self(), clock:get_time(),Ref,CPID]),
					CPID ! {cup, Ref},
					work();
				no_serve ->
					work()
			end;
		close -> 
			main:getOrderList() ! {rem_worker, self()},
			io:format("Process ~w at ~w: Chef is leaving ~n",[self(), clock:get_time()]),
			main:getOwner() ! {bye, self(), 0}
	end.
