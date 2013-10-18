-module(main).
-export([start/1, getOrderList/0, getOwner/0, getChef/0]).



start(0) -> io:format("main:start(0) ");
start(N) ->
	io:format("main:start(N) where N=~w, ~p~n", [N, self()]),
	register(orderList, spawn(fun() -> orderqueue:init_orderqueue() end)),
	register(owner, spawn(fun() -> owner:init_owner() end)),
	register(chef, spawn(fun() -> chef:init_chef() end)),
	customer:enterCustomers(N).

getOrderList() -> orderList.

getOwner() -> owner.

getChef() -> chef.







	
