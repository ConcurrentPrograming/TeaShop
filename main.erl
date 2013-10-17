-module(main).
-export([start/1, getOrderList/0, getOwner/0, getChef/0]).



start(0) -> 0;
start(N) ->
	register(orderList, spawn(orderqueue, orderqueue:order())),
    register(owner, spawn(owner, owner:work())),
    register(chef, spawn(chef, chef:work())),
	customer:enterCustomers(N).

getOrderList() -> orderList.

getOwner() -> owner.

getChef() -> chef.







	
