-module(main).
-export([start/1, start/0, getOrderList/0, getOwner/0, getChef/0]).



start() -> io:format("main:start(N) where N = nr of customers ~n").

start(N) ->
	io:format("main:start(N) where N=~w, ~p~n", [N, self()]),
	clock:start(1),
	register(owner, spawn(fun() -> owner:init_owner() end)),
	register(chef, spawn(fun() -> chef:init_chef() end)),
	register(orderList, spawn(fun() -> orderqueue:init_orderqueue() end)),
	customer:init_door(N).

getOrderList() -> orderList.

getOwner() -> owner.

getChef() -> chef.







	
