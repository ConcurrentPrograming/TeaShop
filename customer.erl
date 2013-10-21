-module(customer).
-export([init_customer/0, enterCustomers/1]).


enterCustomers(0) -> 0;
enterCustomers(N) when N > 0 ->
	spawn(fun() -> init_customer() end),
	%% wait???  time between customers entering!
	enterCustomers(N-1).

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


loop(N) -> 
	receive
		cup -> 
			io:format("Customer ~p received a cup of tea~n",[self()]),
			%% start timer for reciving cup_finnished
			clock:setAlarm({0,10,00}, cup_finnished),
			loop(N);
		cup_finnished ->
			order(N-1);
		last_call -> 0
	end.
	
