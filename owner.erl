-module(owner).
-export([init_owner/0]).


init_owner() ->
	io:format("owner is initiated ~p~n",[self()]),
	List = [],
	work(List).



work(List) ->
	%io:format("List=~w~n", [List]),
	receive
		{hello, PID} ->
			io:format("Customer ~p said hello to owner~n", [PID]),
			NewList = [PID | List],
			work(NewList);
		{bye, PID} -> 
			io:format("Customer ~p said Bye Bye to owner~n", [PID]),
			NewList = lists:delete(PID, List),
			work(NewList)
	end.
