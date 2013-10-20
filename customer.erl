-module(customer).
-export([init_customer/0, enterCustomers/1]).


enterCustomers(0) -> 0;
enterCustomers(N) when N > 0 ->
	spawn(fun() -> init_customer() end),
	%% wait???  time between customers entering!
	enterCustomers(N-1).

init_customer() ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = random:uniform(15) + 1,
	io:format("Customer ~p enterd and is planing to drink ~w cupps of tea ~n", [self(), N]),
	main:getOwner() ! {hello, self()}, %% säg hej till ägaren!!!
	order(N).


order(0) ->
	main:getOwner() ! {bye, self()};
order(N) -> 
	main:getOrderList() ! {order, self()},
	receive
		cup -> 
			%%kunden får en kopp te
			%%wait   == tiden det tar o dricka en kopp!
			io:format("Customer ~p recived a cup of tea~n",[self()]),
			order(N-1); %% tillsvidare
		lastCall -> 0
	end.
	
