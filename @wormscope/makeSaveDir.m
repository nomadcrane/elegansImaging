function makeSaveDir(scope)
global mmc;
tempName=scope.originalExpName;
tempInd=1;
rootFolder=[scope.acqFolder filesep scope.expName];

while exist(rootFolder,'dir')
    tempInd=tempInd+1;
    tempName=[scope.originalExpName '_' num2str(tempInd)];
    rootFolder=[scope.acqFolder filesep tempName];
end
scope.expName=tempName;

for posInd=1:size(scope.posXYZ,1)
    posFolder=[scope.acqFolder filesep scope.expName filesep 'Pos' num2str(posInd)];
    mkdir(posFolder);
end
end