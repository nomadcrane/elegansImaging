function markXYZ(scope)
global mmc;
xLoc=mmc.getXPosition(scope.xyDrive);
yLoc=mmc.getYPosition(scope.xyDrive);
zLoc=mmc.getPosition(scope.zDrive);
scope.posXYZ(scope.currPos,:)=[xLoc yLoc zLoc];
switch scope.afMethod
    case 'PFS'
        scope.posOffset(scope.currPos)=str2num(mmc.getProperty('TIPFSOffset','Position'));
    case 'software'
        scope.posOffset(scope.currPos)=NaN;
end
scope.currPos=scope.currPos+1;
end