-module(customer).
-export([init_customer/0, enterCustomers/1]).


enterCustomers(0) -> 0;
enterCustomers(N) when N > 0 ->
	io:format("customer will be spawn ~n"),
	spawn(customer, init_customer()),
	%% wait???  time between customers entering!
	enterCustomers(N-1).

init_customer() ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = random:uniform(15) + 1,
	io:format("Customer ~p enterd and is planing to drink ~w~n cupps of tea", [self(), N]),
	main:getOwner() ! {hello, self()}, %% säg hej till ägaren!!!
	order(N).


order(0) ->
	main:getOwner() ! {bye, self()};
order(N) -> 
	main:getOrderList() ! {order, self()},
	%receive
	%	cup -> 0;
	%		%%kunden får en kopp te
	%		%%wait   == tiden det tar o dricka en kopp!
	%	lastCall -> 0
	%end,
	order(N-1).
