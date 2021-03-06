function visitXY(scope,xLoc,yLoc)
% this moves the microscope to a specific XY location using a motorized
% stage


global mmc;
mmc.setXYPosition(scope.xyDrive,xLoc,yLoc);
pause(.1);
%             mmc.waitForDevice(scope.xyDrive);
scope.logString=strcat('Moved to Pos: ',num2str(scope.currPos),' at:',datestr(clock));
scope.writeLog;

scope.logString=strcat('Moved to X:',num2str(xLoc),', Y:',num2str(yLoc));
scope.writeLog;
end