function writeLog(scope)
global mmc;
if scope.shouldWriteLog
    fprintf(scope.logFile,scope.logString);
    fprintf(scope.logFile,'\r\n');
end
disp(scope.logString);
end