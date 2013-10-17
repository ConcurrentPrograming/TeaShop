-module(main).
-import(queue,[order/0]).
-import(owner,[]).
-import(chef ,[]).
-import(customer, [enterCustomer/1]).
-export([start/1, getOrderList/0, getOwner/0, getChef/0]).




start(N) ->
	register(orderList, spawn(queue, order())),
    register(owner, spawn(owner, XXXXXXXX, [])),   %% XXXXXX == some function!
    register(chef, spawn(chef, XXXXXXXX, [])),    %% XXXXXX == some function!
	enterCustomers(N).

getOrderList() -> orderList.

getOwner() -> owner.

getChef() -> chef.







	
