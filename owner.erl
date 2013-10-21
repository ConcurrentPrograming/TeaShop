-module(owner).
-export([init_owner/0]).


init_owner() ->
	io:format("owner is initiated ~p~n",[self()]),
	clock:setAlarm({3,0,0}, close),
	clock:setAlarm({2,50,0}, last_call),
	List = [],
	work(List,{0,0,0}).



work(List, {E,H,L}) ->  % E= enterd H= hello L= leave
	%io:format("List=~w~n", [List]),
	receive
		customer_enterd ->
			work(List, {E+1,H,L});
		{hello, PID} ->
			io:format("Customer ~p said hello to owner~n", [PID]),
			NewList = lists:append([PID],List),
			work(NewList, {E,H+1,L});
		{bye, PID} -> 
			io:format("Customer ~p said Bye Bye to owner~n", [PID]),
			NewList = lists:delete(PID, List),
			work(NewList, {E,H,L+1});
		last_call ->
			lastCall(List),
			work(List, {E,H,L});
		close -> 
<<<<<<< HEAD
			main:getChef() ! close,
			work(List, {E,H,L});
=======
			main:getChef() ! close;
>>>>>>> 21e2cca5555af67360b8ef1de522d35657a83502
		{serve, Customer} ->
			io:format("Owner is serving a cup of tea to customer ~p~n",[Customer]),
			Customer ! cup,
			work(List, {E,H,L});
		list_not_empty ->
			main:getOrderList() ! {checkorder, self()},
			work(List, {E,H,L})
	end.


lastCall(NewList) ->
	case NewList of
		[X|XS] -> 
			X ! last_call,
			lastCall(XS);
		[] ->
			0
	end.
