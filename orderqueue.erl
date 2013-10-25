-module(orderqueue).
-export([init_orderqueue/0]).

init_orderqueue() ->
	List = [],
	io:format("Process ~w at ~w: Orderqueue is initiated ~n", [self(), clock:get_time()]),
	order(List,[]).

order(List,Workers) ->
	%io:format("orderqueue:order(List) (~p) where List=~w~n", [self(),List]),
	receive
		{add_worker, PID} ->  %% add chef/owner to the list of people who can serve
			NewWorkers = lists:append([PID],Workers),
			order(List,NewWorkers);
		{rem_worker, PID} ->  %% remove chef/owner to the list of people who can serve
			NewWorkers = lists:delete(PID, Workers),
			order(List,NewWorkers);
		{order, PID, Ref} -> 	%customer orders a cup!
			io:format("Process ~w at ~w: customer ~p orderd a cup of tea (~p)~n", [self(), clock:get_time(),PID,Ref]),
			NewList = lists:append(List,[{PID,Ref}]),
			listNotEmpty(Workers),
			order(NewList,Workers);
		{checkorder, PID} ->  % PID being either owner or chef!
			case List of 
				[{CPID,Ref}|XS] -> 
					PID ! {serve, CPID, Ref}, % X being the customer that should be served by PID (owner/chef)
					order(XS, Workers);
				[] -> 
					PID ! no_serve,
					order(List, Workers)
			end
	end.

listNotEmpty(Workers) -> % send out list_not_empty to the workers who are still in the building
	case Workers of 
		[X|XS] -> 
			X ! list_not_empty, % X being (owner/chef)
			listNotEmpty(XS);
		[] -> 
			''
	end.
