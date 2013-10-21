-module(owner).
-export([init_owner/0]).


init_owner() ->
	io:format("owner is initiated ~p~n",[self()]),
	List = [],
	work(List).



work(List, {e,h,l}) ->  % e= enterd h= hello l= leave
	%io:format("List=~w~n", [List]),
	receive
		customer_enterd ->
			work(List, {e+1,h,l});
		{hello, PID} ->
			io:format("Customer ~p said hello to owner~n", [PID]),
			NewList = lists:append([PID],List),
			work(NewList, {e,h+1,l});
		{bye, PID} -> 
			io:format("Customer ~p said Bye Bye to owner~n", [PID]),
			NewList = lists:delete(PID, List),
			work(NewList, {e,h,l+1});
		last_call ->
			lastCall(List,List, {e,h,l}),
			work(List, {e,h,l});
		{serve, Customer} ->
			io:format("Owner is serving a cup of tea to customer ~p~n",[Customer]),
			Customer ! cup,
			work(List, {e,h,l});
		list_not_empty ->
			main:getOrderList() ! {checkorder, self()},
			work(List, {e,h,l})
	end.


lastCall(NewList, OldList, {e,h,l}) ->
	case NewList of
		[X|XS] -> 
			X ! last_call,
			lastCall(XS, OldList, {e,h,l});
		[] ->
			work(OldList, {e,h,l})
	end.
