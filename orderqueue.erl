-module(orderqueue).
-export([init_orderqueue/0]).

init_orderqueue() ->
	List = [],
	io:format("orderqueue is initiated ~p~n", [self()]),
	order(List).

order(List) ->
	%io:format("orderqueue:order(List) (~p) where List=~w~n", [self(),List]),
	receive
		{order, PID} -> 	%customer order a cup!
			io:format("customer ~p orderd a cup of tea ~n", [PID]),
			NewList = lists:append(List,[PID]),
			main:getOwner() ! list_not_empty,
			main:getChef() ! list_not_empty,
			order(NewList);
		{checkorder, PID} ->  % PID being either owner or chef!
			case List of 
				[X|XS] -> 
					PID ! {serve, X}, % X being the customer that should be served by PID (owner/chef)
					order(XS);
				[] -> 
					order(List)
			end
	end.
