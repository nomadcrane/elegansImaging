function runAutoWormImaging(wormscope)
    % runAutoWormImaging
    % This function works to automatically acquire images of C elegans as
    % they entire the imaging portion of the microfluidic device. It is
    % designed to acquire a specific number of images of animals, and then
    % halt execution. It has not been fully debugged, so it likely has
    % issues. 
    
global mmc;
global gui;
gui.closeAllAcquisitions();
gui.clearMessageWindow();
mmc.stopSequenceAcquisition;%Will allow acquisition to run if someone has

wormscope.makeSaveDir;
wormscope.setLogFile([wormscope.acqFolder filesep wormscope.expName filesep 'logFile.txt']);
fname=strcat(wormscope.acqFolder, filesep, wormscope.expName, filesep,'scope.mat');
wormscope.shouldWriteLog=true;
save(fname,'scope');

% run the experiment using a timer;
wormscope.currFrame=1;
wormscope.currCh=1;

wormscope.setupLoopAcq;

wormscope.imHeight=mmc.getImageHeight();
wormscope.imWidth=mmc.getImageWidth();

wormscope.abortRun=false;
for frameInd=1:wormscope.numWormsToCapture
    if wormscope.abortRun
        break;
    end
    wormscope.currFrame=frameInd;
    wormscope.wormLoading;
    
    mmc.snapImage();
    img=mmc.getImage;
    
    img2=typecast(img,'uint16');
    img2=reshape(img2,[wormscope.imHeight,wormscope.imWidth]);
    filename=strcat(scope.acqFolder, filesep, scope.expName, filesep, ...
        scope.expName,'_',sprintf('%06d',scope.currFrame),'.tif');
    imwrite(img2,char(filename),'tif');
    
    wormscope.currentIm=img2;
    wormscope.recentSavedIm=img2;


    
end

