classdef wormscope<handle
    properties
        
        currFrame %absolute frame from start of the experiment
        currCh %current channel number
        
        logFile
        logString
        shouldWriteLog %bool true/false for whether the log should be written
        acqFolder %folder where images should be saved
        expName %name of the experiment
        originalExpName
        loopParams
        
        imWidth
        imHeight
        exposTime
        binningValue
        
        posXYZ %matrix where each row is position, and columns are x,y,z
        posOffset %
        
        autoLoadImCVThresh % CV of image which is used to determine whether a worm is present
        lastImCV %CV of previous image
        
        sValve %struct containting the numbers of for the valves to call. 
        % should have injection/entry/position/flush/exit1/exit2 valve info
        % if sorting wt/mut - exit1 should be the wt
        
        cSolenoidValves %class of type solenoidValveGUI which allows valve actuation
        
        speedLoadDelay %delay time to leave all valves open to speed loading - should be short (~.3s)
        releaseDelay %delay time to allow worm to be released after imaging  
        delayTimeBeforeLoadFlush %time to wait during loading before running a flush - should be long (>10s)
        
        abortRun %parameter to abort a run that is happening (logical)
        currentIm %contains the most recent image acquired by the camera. For use
        %to update a figure so user can see what is happening
        recentSavedIm %image most recent acquired to save
    end
    
    methods
        
        function wormscope=wormscope()
            global mmc
            
            wormscope.currFrame=1;
            wormscope.currCh=1;
            
%             wormscope.cSolenoidValves=solenoidValveGUI;
            try
                wormscope.imHeight=mmc.getImageHeight();
                wormscope.imWidth=mmc.getImageWidth();
                mmc.setProperty(mmc.getCameraDevice, 'PixelType', '16bit-MONO')
            catch
            end
            
            try
                wormscope.cSolenoidValves=solenoidValveGUI;
            catch
            end
            %default parameters
            wormscope.speedLoadDelay = 10;
            wormscope.releaseDelay = 0.6;
            wormscope.delayTimeBeforeLoadFlush = 10;
            wormscope.autoLoadImCVThresh = 0.3;
            wormscope.lastImCV = NaN;
            wormscope.exposTime = 30;
            wormscope.binningValue = 1;
            wormscope.sValve.entry=0;
            wormscope.sValve.position=3;
            wormscope.sValve.exit1=4;
            wormscope.sValve.exit2=5;
            wormscope.sValve.flush=6;
            wormscope.sValve.injection = 7;

            
            wormscope.sValve.nopower=false;
            wormscope.sValve.powered=true;
            %numFrames - frames to acquire in that part of the loop [1]
        end
                        
        function setExpName(wormscope,expName,acqFolder)
            global mmc
            if nargin<2 || isempty(expName)
                [expName,acqFolder] = uiputfile;
            end
            wormscope.originalExpName=expName;
            wormscope.expName=expName;
            wormscope.acqFolder=acqFolder;
        end
        
        
        function setAcqFolder(wormscope,acqFolder)
            if nargin<2 || isempty(acqFolder)
                acqFolder = uigetdir(wormscope.acqFolder);
            end
            if acqFolder
                wormscope.acqFolder=acqFolder;
            end
        end
        
        function setLogFile(wormscope,logName)
            global mmc
            if nargin<2 || isempty(logName)
                logName = uiputfile;
            end
            wormscope.logFile=fopen(logName,'w');
        end
        
        function setExposTime(wormscope,exposTime)
            global mmc
            wormscope.exposTime=exposTime;
            mmc.setExposure(wormscope.exposTime);
        end

        function setBinning(wormscope,binning)
            global mmc
            wormscope.binningValue=binning;
            mmc.setProperty(mmc.getCameraDevice, 'Binning', num2str(binning));
            wormscope.imHeight=mmc.getImageHeight();
            wormscope.imWidth=mmc.getImageWidth();
        end

        
    end
end
