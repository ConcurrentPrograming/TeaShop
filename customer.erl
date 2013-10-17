-module(customer).
-import(main, [getOrderList/0, getOwner/0]).
-export([init_customer/0, enterCustomers/1]).



init_customer() ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = random:uniform(15) + 1,
	getOwner ! {hello, self()}, %% säg hel till ägaren!!!
	order(N).


enterCustomers(0) -> 0;
enterCustomers(N) when N > 0 ->
	spawn(customer, init_customer),
	%% wait???  time between customers entering!
	enterCustomers(N-1).





order(0) ->
	getOwner ! {bye, self()};
order(N) -> 
	getOrderList() ! {order, self()},
	receive
		cup -> 0;
			%%kunden får en kopp te
			%%wait   == tiden det tar o dricka en kopp!
		lastCall -> 0
	end,
	order(N-1).
