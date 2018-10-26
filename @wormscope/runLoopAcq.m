function runLoopAcq(scope)
% runs the image acquisition for each timepoint in the loop

disp('');

%Ken's additions, display and log memory usage%
[userview systemview] = memory;
availMemStr = num2str(systemview.PhysicalMemory.Available)


scope.logString=strcat('\r\n\n------Time point_',num2str(scope.currFrame),'------', ' Available Memory: ', availMemStr);
% end Ken's additions

scope.writeLog;
try
    for posInd=1:size(scope.posXYZ,1)
        scope.currPos=posInd;
        scope.visitPosUpdateAF;
        for chInd=1:length(scope.loopParams(scope.currLoop).channels)
            if ~rem(scope.loopFrame-1,scope.loopParams(scope.currLoop).skip(chInd))
                scope.currCh=chInd;
                scope.setFilters;
                if strcmp(scope.loopParams(scope.currLoop).channels{scope.currCh},'BF') && ...
                        strcmp(scope.afMethod,'Software')
                    scope.useAFSTackBF
                else
                    scope.acquireStackLoop;
                end
            end
        end
    end
    
    scope.currFrame=scope.currFrame+1;
    scope.loopFrame=scope.loopFrame+1;
    
    intT=scope.loopParams(scope.currLoop).interval;
    remT=num2str(intT*(scope.loopFrame-1)-toc(scope.loopTimer.UserData)+scope.loopTimer.StartDelay);
    
    disp(['Timer waiting until next timepoint - ' remT ' (s)'])
    
    scope.logString=strcat('Time to next time point: ',num2str(remT));
    scope.writeLog;
catch
    b=1
end

end