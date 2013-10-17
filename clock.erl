-module(clock).
-export([get_time/0, start/1, start/2, stop/0, setAlarm/2, add_time/2]).

%% The clock will run at the speed 1:1000/Timescale - that is, if Timescale
%% is 10 then one simulated second will take 10 milliseconds.
%% The second argument to start/2 gives the starting time of the simulation.
%% You are recommended to use start/1 instead.
start(Timescale) -> start(Timescale, {0,0,0}).
start(Timescale, {H,M,S}) ->
    case whereis(clockproc) of
        undefined ->
            timer:start(),
            Pid = spawn(fun() ->
                    TRef = timer:send_interval(Timescale, self(), tick),
                    clock_loop(TRef, H*3600+M*60+S, [])
                  end),
            register(clockproc, Pid),
            ok;
        _ ->
            already_running
    end,
    io:format("Clock started.~n", []).

%% Kill the clock.
stop() -> clockproc ! die.

%% Return the current simulation time in the format {hour, minute, second}.
get_time() ->
    clockproc ! {get_time, self()},
    receive {get_time, T} -> T end.

%% Receive a message Msg {H,M,S} hours/minutes/seconds (simulation time) into
%% the future. If the current time is {13,00,00} and
%% clock:setAlarm({1,30,00}, blah) is called, the calling process will receive
%% a message 'blah' at {14,30,00}.
setAlarm({H,M,S}, Msg) ->
    clockproc ! {add_alarm, H*3600+M*60+S, self(), Msg}.

clock_loop(TRef, CurSecs, Alarms) ->
    receive
        {get_time, Asker} ->
            {H,M} = {CurSecs div 3600, (CurSecs rem 3600) div 60},
            Asker ! {get_time, {H,M,CurSecs rem 60}},
            clock_loop(TRef, CurSecs, Alarms);
        die ->
            timer:cancel(TRef),
            ok;
        tick ->
            case Alarms of
                [{Secs, Pid, Msg} | Rest] when Secs =< CurSecs ->
                    Pid ! Msg,
                    clock_loop(TRef, CurSecs+1, Rest);
                _ ->
                    clock_loop(TRef, CurSecs+1, Alarms)
            end;
        {add_alarm, T, Pid, Msg} ->
            Alarm = {CurSecs + T, Pid, Msg},
            clock_loop(TRef, CurSecs, lists:sort([Alarm | Alarms]))
    end.

%% Add the second argument to the first.
add_time({H,M,S}, {Hdiff, Mdiff, Sdiff}) ->
    T = H*3600 + M*60 + S,
    Tdiff = Hdiff*3600 + Mdiff*60 + Sdiff,
    T2 = T + Tdiff,
    H2 = T2 div 3600,
    M2 = (T2 rem 3600) div 60,
    S2 = T2 rem 60,
    {H2,M2,S2}.
