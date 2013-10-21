-module(customer).
-export([init_customer/0, enterCustomers/1]).


enterCustomers(0) -> 0;
enterCustomers(N) when N > 0 ->
	spawn(fun() -> init_customer() end),
	main:getOwner() ! customer_enterd,
	RandomHour = crypto:rand_uniform(0,2),
	RandomMinutes = crypto:rand_uniform(0,20),
	clock:setAlarm({RandomHour,RandomMinutes,00}, next_customer),
	receive
	   next_customer ->
		enterCustomers(N-1)
	end.	

init_customer() ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = crypto:rand_uniform(1, 15),	
	io:format("Customer ~p enterd and is planing to drink ~w cupps of tea ~n", [self(), N]),
	main:getOwner() ! {hello, self()}, %% säg hej till ägaren!!!
	order(N).


order(0) ->
	main:getOwner() ! {bye, self()};
order(N) ->
	main:getOrderList() ! {order, self()},
	loop(N).

make_last_order() ->
	order(1).

loop(N) -> 
	receive
		cup -> 
			io:format("Customer ~p received a cup of tea~n",[self()]),
			%% start timer for reciving cup_finnished
			clock:setAlarm({0,50,00}, cup_finnished),
			loop(N);
		cup_finnished ->
			order(N-1);
		last_call -> 
			RandomNumber = crypto:rand_uniform(1,3),
			case RandomNumber of
				1 ->
				io:format("~p fastly drinks his/her cup to order one last... ~n" , [self()]),
				make_last_order();
				2->
				io:format("~p sits back and relaxes with his/her last cup  ~n" , [self()]),
				order(0)
			end
	end.
	
