-module(customer).
-export([init_customer/0, enterCustomers/1, init_door/1]).


init_door(N) ->
	register(door,self()),
	enterCustomers(N).

enterCustomers(0) -> 0;
enterCustomers(N) when N > 0 ->
	spawn(fun() -> init_customer() end),
	main:getOwner() ! customer_enterd,
	RandomMinutes = crypto:rand_uniform(0,59),
	clock:setAlarm({0,RandomMinutes,00}, next_customer),
	receive
		close -> 
			io:format("Process ~w at ~w: A customer was stopped from entering since its to late~n", [self(), clock:get_time()]);
	   	next_customer ->
			enterCustomers(N-1)
	end.	

init_customer() ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = crypto:rand_uniform(1, 15),	
	io:format("Process ~w at ~w: Customer ~p enterd and is planing to drink ~w cupps of tea ~n", [self(), clock:get_time(), self(), N]),
	main:getOwner() ! {hello, self()}, %% säg hej till ägaren!!!
	order(N, false).


order(0,_) ->
	main:getOwner() ! {bye, self()};
order(N,L) ->
	main:getOrderList() ! {order, self()},
	loop(N, L).


loop(N, L) ->  % N = number of cupps L = LastCall
	receive
		cup -> 
			%% start timer for reciving cup_finnished
			Time = crypto:rand_uniform(5, 30),
			clock:setAlarm({0,Time,00}, cup_finnished),
			loop(N, L);
		cup_finnished ->
			case L of
				false ->
					order(N-1, L);
				true ->
					order(0, L)
			end;
		last_call -> 
			RandomNumber = crypto:rand_uniform(1,3),  %% some customers behave diffrently
			case RandomNumber of
				1 -> 
					order(1, true);
				2 ->
					loop(0,true)
			end
	end.
	
