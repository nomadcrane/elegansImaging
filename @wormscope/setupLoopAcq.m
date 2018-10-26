function setupLoopAcq(scope,startDelay)
% sets up the timer, for the current loop parameters and then starts it

if nargin<2
    startDelay=0;
end

if startDelay<0
    startDelay=0;
end

currLoop=scope.currLoop;

try stop(scope.loopTimer)
end

scope.loopTimer=timer;
scope.loopTimer.Period         = scope.loopParams(currLoop).interval;
scope.loopTimer.ExecutionMode  = 'fixedRate';
scope.loopTimer.TimerFcn       = @(src,event)runLoopAcq(scope);
scope.loopTimer.StopFcn       = @(src,event)startNewLoop(scope);
scope.loopTimer.BusyMode       = 'queue';
scope.loopTimer.TasksToExecute = scope.loopParams(currLoop).numFrames;
scope.loopTimer.UserData       = tic;
scope.loopTimer.StartDelay = startDelay;
start(scope.loopTimer)
end