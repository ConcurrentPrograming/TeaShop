-module(comp).
-export([all/0]).

all() -> 
	Msg = c:flush(),
	io:format("flush() ~p~n", [Msg]),
	Msg1 = compile:file(main),
	io:format("~p~n", [Msg1]),
	Msg2 = compile:file(customer),
	io:format("~p~n", [Msg2]),
	Msg3 = compile:file(owner),
	io:format("~p~n", [Msg3]),
	Msg4 = compile:file(chef),
	io:format("~p~n", [Msg4]),
	Msg5 = compile:file(orderqueue),
	io:format("~p~n", [Msg5]),
	Msg6 = compile:file(clock),
	io:format("~p~n", [Msg6]).
