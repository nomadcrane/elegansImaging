function runAcq(scope)
%starts the image acquisition run

global mmc;
global gui;
gui.closeAllAcquisitions();
gui.clearMessageWindow();
mmc.stopSequenceAcquisition;%Will allow acquisition to run if someone has

if strcmp(scope.afMethod,'PFS')
    mmc.setProperty('TIPFSStatus','State','Off');
end

if strcmp(scope.name,'Nikon')
    mmc.setProperty('TILightPath','State','1');
end
scope.afOn=false;
pause(.1);
scope.makeSaveDir;
scope.setLogFile([scope.acqFolder filesep scope.expName filesep 'logFile.txt']);
fname=strcat(scope.acqFolder, filesep, scope.expName, filesep,'scope.mat');
scope.shouldWriteLog=true;
save(fname,'scope');

% run the experiment using a timer;
scope.currLoop=1;
scope.currPos=1;
scope.currFrame=1;
scope.currCh=1;
scope.loopFrame=1;

scope.setupLoopAcq;

%below is old stuff to run using a 'dumb' for loop
%             frameIndAbs=0;
%             for loopInd=1:length(scope.loopParams)
%                 startT=tic;
%                 scope.currLoop=loopInd;
%                 for frameInd=1:scope.loopParams(scope.currLoop).numFrames
%                     frameIndAbs=frameIndAbs+1;
%                     scope.currFrame=frameIndAbs;
%                     for posInd=1:size(scope.posXYZ,1)
%                         scope.currPos=posInd;
%                         scope.visitPosUpdateAF;
%                         for chInd=1:length(scope.loopParams(scope.currLoop).channels)
%                             if ~rem(frameInd,scope.loopParams(scope.currLoop).skip(chInd))
%                                 scope.currCh=chInd;
%                                 scope.setFilters;
%                                 scope.acquireStackLoop;
%                             end
%                         end
%                     end
%                     disp('Really dumb pause snce interval not coded yet')
%                     intT=scope.loopParams(scope.currLoop).interval;
% %                     intT*frameInd-toc(startT)
%                     disp(num2str(intT*frameInd-toc(startT)));
%                     pause(intT*frameInd-toc(startT));
%                 end
%             end
end
