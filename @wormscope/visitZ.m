function visitZ(scope,zLoc)
global mmc;
mmc.setPosition(scope.zDrive,zLoc);
%             mmc.waitForDevice(scope.zDrive);
scope.logString=strcat('Moved to Z:',num2str(zLoc));
scope.writeLog;
end