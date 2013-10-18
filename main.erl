-module(main).
-export([start/1, getOrderList/0, getOwner/0, getChef/0]).



start(0) -> io:format("main:start(0) ");
start(N) ->
	io:format("main:start(N) where N=~w~n", [N]),
	register(orderList, spawn(orderqueue, orderqueue:init_orderqueue(), [])),
	register(owner, spawn(owner, owner:init_owner(), [])),
	register(chef, spawn(chef, chef:init_chef(), [])),
	customer:enterCustomers(N).

getOrderList() -> orderList.

getOwner() -> owner.

getChef() -> chef.







	
