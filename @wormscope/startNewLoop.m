function startNewLoop(scope)
% this is to see if once the timer function is finished, if it should
% run another loop. If so, it sets up the new loop and then starts it
scope.currLoop=scope.currLoop+1;
if scope.currLoop<=length(scope.loopParams)
    intT=scope.loopParams(scope.currLoop-1).interval;
    remT=intT*(scope.loopFrame-1)-toc(scope.loopTimer.UserData)+scope.loopTimer.StartDelay;
    scope.loopFrame=1;
    scope.setupLoopAcq(floor(remT));
end
end