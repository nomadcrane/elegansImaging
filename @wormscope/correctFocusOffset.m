function correctFocusOffset(scope)
global mmc
switch scope.afMethod
    case 'PFS'
%         scope.turnOnAF;
        pause(.15);
        if isempty(scope.currFocusOffset)
            scope.currFocusOffset=mmc.getProperty('TIPFSOffset','Position');
        end
        if scope.currFocusOffset ~= scope.posOffset(scope.currPos)
            mmc.setProperty('TIPFSOffset','Position',scope.posOffset(scope.currPos));
        end
        
        if true
            afStatus=mmc.getProperty('TIPFSStatus','Status');
            if strcmp(afStatus,'Out of focus search range')
                pause(.3);
                disp('Waiting for focus range');
                afStatus=mmc.getProperty('TIPFSStatus','Status');
            end
            while strcmp(afStatus,'Within range of focus search') && ~strcmp(afStatus,'Out of focus search range') && ~strcmp(afStatus,'Focusing')
                scope.afOn=false;
                scope.turnOnAF;
                pause(0.2);
                afStatus=mmc.getProperty('TIPFSStatus','Status');
                disp('Turning PFS ON');
            end
            while strcmp(afStatus,'Focusing')
                pause(.2);
                afStatus=mmc.getProperty('TIPFSStatus','Status');
                disp('Waiting to focus');
            end
        end
        zLoc=mmc.getPosition(scope.zDrive);
        pause(.02);
    case 'software'
        disp('software autofocus not done yet');
        chName=scope.loopParams(scope.currLoop).channels{1};
        expos=scope.loopParams(scope.currLoop).exposureTime(1);
        mmc.setConfig('Channel', chName);
        mmc.setExposure(expos);
        mmc.waitForConfig('Channel', chName);

        
        [imStack zPos]=scope.getAFStack;
        aF=[];
        for sliceInd=1:size(imStack,3)
            tIm=imStack(:,:,sliceInd);
            tIm=double(tIm);
            aF(sliceInd)=std(tIm(:))/mean(tIm(:));
        end
        %aF(1)=mean(aF(:));
        aF=smooth(aF,3);
        figure(123);plot(aF);
        [v minInd]=min(aF);
        zLoc=zPos(minInd);
        
        scope.afRelLoc=zPos-zLoc;
        scope.afStack=imStack;
        
        %check to make sure that the zposition hasn't drifted too far from
        %the starting location (don't want to accidentally break the
        %coverslip)
        if isfield(scope.afParams,'startingZPos')
            if isempty(scope.afParams,'startingZPos')
                scope.afParams.startingZPos=nanmean(scope.posXYZ(:,3));
            end
        else
            scope.afParams.startingZPos=nanmean(scope.posXYZ(:,3));
        end
        if abs(zLoc-scope.afParams.startingZPos)>50
            zLoc=scope.afParams.startingZPos;
        end
end
scope.posXYZ(scope.currPos,3)=zLoc;
scope.logString=strcat('Pos ',num2str(scope.currPos),' z updated to: ', num2str(zLoc));
scope.writeLog;
end