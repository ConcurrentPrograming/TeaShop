-module(owner).
-export([init_owner/0]).


init_owner() ->
	io:format("Process ~w at ~w: Owner is initiated~n",[self(),clock:get_time()]),
	clock:setAlarm({5,0,0}, close),
	clock:setAlarm({4,50,0}, last_call),
	List = [],
	work(List,{0,0,0}, false).



work(List, {E,H,L}, C) ->  % {E= enterd H= hello L= leave} (nr) C= close (true/false)
	%io:format("List=~w~n", [List]),
	receive
		customer_enterd ->
			work(List, {E+1,H,L}, C);
		{hello, PID} ->
			io:format("Process ~w at ~w: Customer ~p said hello to owner~n", [self(), clock:get_time(),PID]),
			NewList = lists:append([PID],List),
			work(NewList, {E,H+1,L}, C);
		{bye, PID} -> 
			io:format("Process ~w at ~w: Customer ~p said Bye Bye to owner~n", [self(), clock:get_time(),PID]),
			NewList = lists:delete(PID, List),
			case {NewList,C} of 
				{[],true} ->
					close({E,H,L+1});
				{_,_} ->
					work(NewList, {E,H,L+1}, C)
			end;
		last_call ->
			door ! close,
			io:format("Process ~w at ~w: Owner screams out loud: Last call people! ~n",[self(), clock:get_time()]),
			lastCall(List),
			work(List, {E,H,L}, C);
		close -> 
			main:getChef() ! close,
			case List of 
				[] -> 
					close({E,H,L});
				_ -> work(List, {E,H,L}, true)
			end;
		{serve, Customer} ->
			io:format("Process ~w at ~w: Owner is serving a cup of tea to customer ~p~n",[self(), clock:get_time(),Customer]),
			Customer ! cup,
			work(List, {E,H,L}, C);
		list_not_empty ->
			main:getOrderList() ! {checkorder, self()},
			work(List, {E,H,L}, C)
	end.


lastCall(NewList) ->
	case NewList of
		[X|XS] -> 
			X ! last_call,
			lastCall(XS);
		[] ->
			0
	end.

close({E,H,L}) ->
	clock:stop(),
	io:format("~n~n Result:~n"),
	io:format("Number of Customers who enterd: ~w~n", [E]),
	io:format("Number of Customers who said hello: ~w~n", [H]),
	io:format("Number of Customers who left: ~w~n", [L]),
	io:format("----------------------------------------------~n").
