-module(main).

-export([start/1]).




start(N) ->
	register(orderList, spawn(queue, order())),
    register(owner, spawn(main, XXXXXXXX, [])),   %% XXXXXX == some function!
    register(chef, spawn(main, XXXXXXXX, [])),    %% XXXXXX == some function!
	enterCustomers(N).





enterCustomers(0) -> ;
enterCustomers(N) when N > 0 ->
	cust_pid = spawn(customer, init_customer, [orderList]),
	tmp_list = [cust_pid | cust_list ],
	Cust_list = tmp_list,
	%% wait???
	enterCustomer(N-1).




	
