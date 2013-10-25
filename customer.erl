-module(customer).
-export([init_door/1]).


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
			enterCustomers(0);
	   	next_customer ->
			enterCustomers(N-1)
	end.	

init_customer() ->
	%% N = slumpa antal koppar som denna kund vill dricka
	N = crypto:rand_uniform(1, 15),	
	io:format("Process ~w at ~w: Customer ~p enterd and is planing to drink ~w cupps of tea ~n", [self(), clock:get_time(), self(), N]),
	main:getOwner() ! {hello, self(), 1}, %% säg hej till ägaren!!!
	order(N, false).


order(0,_) ->
	main:getOwner() ! {bye, self(), 1};
order(N,L) ->
	main:getOrderList() ! {order, self(), make_ref()},
	loop(N, L, 0).


loop(N, L, Cup) ->  % N = number of cupps L = LastCall Cup = a make_ref() refrence to current cup
	receive
		{cup, Ref} -> 
			%% start timer for reciving cup_finnished
			Time = crypto:rand_uniform(5, 30),
			clock:setAlarm({0,10,00}, {cup_finnished, Ref}),
			loop(N, L, Ref);
		{cup_finnished, Ref} ->
			case {L,Cup==Ref} of  %% last call
				{false,_} ->
					order(N-1, L);
				{true,true} ->
					order(0, L);
				{true,false} ->
					loop(N, L, Cup)
			end;
		last_call -> 
			RandomNumber = crypto:rand_uniform(1,3),  %% some customers behave diffrently
			case RandomNumber of
				1 -> 
					order(1, true);  %% chuggs to order again
				2 ->
					loop(0,true, Cup)
			end
	end.
	
