-module(customer).
-export([init_customer/1]).



init_customer(orderList) ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = random:uniform(15) + 1,
	owner ! {hello, self()},
	order(N, orderList).


order(0, orderList) ->
	orderList ! {done, self()};
order(N, order_pid) -> 
	orderList ! {order, self()},
	%%wait   == tiden det tar o dricka en kopp!
	order(N-1, orderList).
