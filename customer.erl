-module(customer).
-import(main, [getOrderList/0]).
-export([init_customer/0]).

enterCustomers(0) -> 0;
enterCustomers(N) when N > 0 ->
	cust_pid = spawn(customer, init_customer),
	%% säg hel till ägaren!!!
	%% wait???
	enterCustomer(N-1).

init_customer() ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = random:uniform(15) + 1,
	owner ! {hello, self()},
	order(N).


order(0) ->
	orderList ! {done, self()};
order(N) -> 
	getOrderList() ! {order, self()},
	%%wait   == tiden det tar o dricka en kopp!
	order(N-1).
