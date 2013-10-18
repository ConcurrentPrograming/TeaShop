-module(orderqueue).
-export([init_orderqueue/0]).

init_orderqueue() ->
	List = [],
	order(List).

order(List) ->
	io:format("orderqueue:order(List) (~p) where List=~w~n", [self(),List]),
	receive
		{order, PID} -> 	%customer order a cup!
			NewList = lists:append(List,[PID]),
			main:getOwner() ! listNotEmpty,
			main:getChef() ! listNotEmpty,
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
