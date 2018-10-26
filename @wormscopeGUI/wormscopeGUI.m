classdef wormscopeGUI<handle
    properties
        figure = [];
        expPanel
        valvePanel
        imagesPanel
        
        expNameText
        rootFolderLabel
        rootFolderText
        selectRootFolderButton
        runAutoImagingButton
        stopExpButton
        
        
        setEntryValveLabel
        setPosValveLabel
        setExit1ValveLabel
        setExit2ValveLabel
        setFlushValveLabel
        setInjectionValveLabel
        
        setEntryValveText
        setPosValveText
        setExit1ValveText
        setExit2ValveText
        setFlushValveText
        setInjectionValveText
        
        setAutoLoadThreshLabel
        setAutoLoadThreshText
        lastImCVLabel
        lastImCVText
        setFlushTimeLabel
        setFlushTimeText
        setLoadDelayBeforeFlushLabel
        setLoadDelayBeforeFlushText
        setExposTimeLabel
        setExposTimeText
        setBinningLabel
        setBinningPopup
        
        wormAutoLoadingValveButton
        wormLoadingValveButton
        wormPresentValveButton
        wormExit1Button
        wormExit2Button
        
        setCurrentImgLabel
        setPrevImgLabel
        
        currentImFig
        recentlySavedImFig
        
        wormscope
    end % properties
    %% Displays timelapse for a single trap
    %This can either dispaly the primary channel (DIC) or a secondary channel
    %that has been loaded. It uses the trap positions identified in the DIC
    %image to display either the primary or secondary information.
    methods
        function uscopeGUI=wormscopeGUI(title)
            
            wscope=wormscope;
            uscopeGUI.wormscope=wscope;
            
            if nargin<2
                title='Microscope GUI';
            end
            
            scrsz = get(0,'ScreenSize');
            uscopeGUI.figure=figure('MenuBar','none','Name',title,'Position',[scrsz(3)/3 scrsz(4)/3 scrsz(3)/2 scrsz(4)/2]);
            uscopeGUI.expPanel = uipanel('Parent',uscopeGUI.figure,...
                'Position',[.015 .83 .97 .16 ]);
            uscopeGUI.valvePanel = uipanel('Parent',uscopeGUI.figure,...
                'Position',[.015 .60 .97 .22 ]);

            uscopeGUI.imagesPanel = uipanel('Parent',uscopeGUI.figure,...
                'Position',[.015 .02 .97 .58]);
            
            uscopeGUI.rootFolderLabel = uicontrol(uscopeGUI.expPanel,'Style','text','String','Root Folder of Experiment',...
                'Units','normalized','Position',[.025 .625 .4 .3]);
            if isempty(uscopeGUI.wormscope.acqFolder)
                stringFolder='No Folder Selected Yet';
            else
                stringFolder=uscopeGUI.wormscope.acqFolder;
            end
            uscopeGUI.rootFolderText = uicontrol(uscopeGUI.expPanel,'Style','edit','String',stringFolder,...
                'Units','normalized','Position',[.005 .55 .6 .45],'Callback',@(src,event)setRootFolder(uscopeGUI));
            uscopeGUI.expNameText = uicontrol(uscopeGUI.expPanel,'Style','edit','String','DefaultExpName',...
                'Units','normalized','Position',[.005 .055 .4 .45],'Callback',@(src,event)setExpName(uscopeGUI));

            uscopeGUI.selectRootFolderButton = uicontrol(uscopeGUI.expPanel,'Style','pushbutton','String','Select Exp Root',...
                'Units','normalized','Position',[.41 .025 .2 .45],'Callback',@(src,event)selectRootFolder(uscopeGUI));
            uscopeGUI.runAutoImagingButton = uicontrol(uscopeGUI.expPanel,'Style','pushbutton','String','Run Auto Imaging',...
                'Units','normalized','Position',[.615 .025 .2 .95],'Callback',@(src,event)runExp(uscopeGUI));
            uscopeGUI.stopExpButton = uicontrol(uscopeGUI.expPanel,'Style','pushbutton','String','Stop Experiment',...
                'Units','normalized','Position',[.835 .025 .15 .95],'Callback',@(src,event)stopExp(uscopeGUI));

            
            uscopeGUI.setEntryValveLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Entry Valve #',...
                'HorizontalAlignment','right','Units','normalized','Position',[.01 .85 .13 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setPosValveLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Position Valve #',...
                'HorizontalAlignment','right','Units','normalized','Position',[.01 .68 .13 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setExit1ValveLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Exit 1 (WT) Valve #',...
                'HorizontalAlignment','right','Units','normalized','Position',[.01 .51 .13 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setExit2ValveLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Exit 2 (Mut) Valve #',...
                'HorizontalAlignment','right','Units','normalized','Position',[.01 .34 .13 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setFlushValveLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Flush Valve #',...
                'HorizontalAlignment','right','Units','normalized','Position',[.01 .17 .13 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setInjectionValveLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Injection Valve #',...
                'HorizontalAlignment','right','Units','normalized','Position',[.01 .01 .13 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            
            uscopeGUI.setEntryValveText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.sValve.entry),...
                'Units','normalized','Position',[.15 .85 .1 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setPosValveText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.sValve.position),...
                'Units','normalized','Position',[.15 .68 .1 .15],'Callback',@(src,event)setPosValve(uscopeGUI));
            uscopeGUI.setExit1ValveText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.sValve.exit1),...
                'Units','normalized','Position',[.15 .51 .1 .15],'Callback',@(src,event)setExit1Valve(uscopeGUI));
            uscopeGUI.setExit2ValveText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.sValve.exit2),...
                'Units','normalized','Position',[.15 .34 .1 .15],'Callback',@(src,event)setExit2Valve(uscopeGUI));
            uscopeGUI.setFlushValveText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.sValve.flush),...
                'Units','normalized','Position',[.15 .17 .1 .15],'Callback',@(src,event)setFlushValve(uscopeGUI));
            uscopeGUI.setInjectionValveText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.sValve.injection),...
                'Units','normalized','Position',[.15 .01 .1 .15],'Callback',@(src,event)setInjectionValve(uscopeGUI));

            uscopeGUI.setAutoLoadThreshLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Auto Load Thresh CV',...
                'HorizontalAlignment','right','Units','normalized','Position',[.3 .85 .14 .15],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setAutoLoadThreshText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.autoLoadImCVThresh),...
                'Units','normalized','Position',[.45 .85 .1 .15],'Callback',@(src,event)setAutoLoadTresh(uscopeGUI));
            uscopeGUI.lastImCVLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','CV of Last Image',...
                'HorizontalAlignment','right','Units','normalized','Position',[.3 .68 .14 .15]);
            uscopeGUI.lastImCVText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.lastImCV),...
                'Units','normalized','Position',[.45 .68 .1 .15]);
            uscopeGUI.setFlushTimeLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Flush Time (s)',...
                'HorizontalAlignment','right','Units','normalized','Position',[.3 .51 .14 .15]);
            uscopeGUI.setFlushTimeText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.releaseDelay),...
                'Units','normalized','Position',[.45 .51 .1 .15],'Callback',@(src,event)setFlushTime(uscopeGUI));
            uscopeGUI.setLoadDelayBeforeFlushLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Load Delay Before Flush (s)',...
                'HorizontalAlignment','right','Units','normalized','Position',[.3 .34 .14 .15]);
            uscopeGUI.setLoadDelayBeforeFlushText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String',num2str(uscopeGUI.wormscope.delayTimeBeforeLoadFlush),...
                'Units','normalized','Position',[.45 .34 .1 .15],'Callback',@(src,event)setLoadDelayBeforeFlush(uscopeGUI));
            uscopeGUI.setExposTimeLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Exposure Time (ms)',...
                'HorizontalAlignment','right','Units','normalized','Position',[.3 .17 .14 .15]);
            uscopeGUI.setExposTimeText = uicontrol(uscopeGUI.valvePanel,'Style','edit','String','30',...
                'Units','normalized','Position',[.45 .17 .1 .15],'Callback',@(src,event)setExposTime(uscopeGUI));
            uscopeGUI.setBinningLabel = uicontrol(uscopeGUI.valvePanel,'Style','text','String','Binning',...
                'HorizontalAlignment','right','Units','normalized','Position',[.3 .01 .14 .15]);
            uscopeGUI.setBinningPopup = uicontrol(uscopeGUI.valvePanel,'Style','popupmenu','String',{'1','2','4'},...
                'Units','normalized','Position',[.45 .01 .1 .15],'Callback',@(src,event)setBinning(uscopeGUI));

            
            uscopeGUI.wormAutoLoadingValveButton = uicontrol(uscopeGUI.valvePanel,'Style','pushbutton','String','Auto Loading',...
                'Units','normalized','Position',[.7 .8 .28 .2],'Callback',@(src,event)wormAutoLoadingValve(uscopeGUI));
            uscopeGUI.wormLoadingValveButton = uicontrol(uscopeGUI.valvePanel,'Style','pushbutton','String','Loading Valves',...
                'Units','normalized','Position',[.7 .6 .28 .2],'Callback',@(src,event)wormLoadingValve(uscopeGUI));
            uscopeGUI.wormPresentValveButton = uicontrol(uscopeGUI.valvePanel,'Style','pushbutton','String','Worm Present Valve',...
                'Units','normalized','Position',[.7 .4 .28 .2],'Callback',@(src,event)wormPresentValve(uscopeGUI));
            uscopeGUI.wormExit1Button = uicontrol(uscopeGUI.valvePanel,'Style','pushbutton','String','Exit 1 Valves',...
                'Units','normalized','Position',[.7 .2 .28 .2],'Callback',@(src,event)wormExit1(uscopeGUI));
            uscopeGUI.wormExit2Button = uicontrol(uscopeGUI.valvePanel,'Style','pushbutton','String','Exit 2 Valves',...
                'Units','normalized','Position',[.7 .01 .28 .2],'Callback',@(src,event)wormExit2(uscopeGUI));
%             uscopeGUI.wormExit2Button = uicontrol(uscopeGUI.posPanel,'Style','pushbutton','String','Exit 2 Valves',...
%                 'Units','normalized','Position',[.7 .05 .28 .2],'Callback',@(src,event)tileXY(uscopeGUI));

            
            uscopeGUI.setCurrentImgLabel = uicontrol(uscopeGUI.imagesPanel,'Style','text','String','Current Image',...
                'HorizontalAlignment','center','Units','normalized','Position',[.05 .9 .5 .1],'Callback',@(src,event)setEntryValve(uscopeGUI));
            uscopeGUI.setPrevImgLabel = uicontrol(uscopeGUI.imagesPanel,'Style','text','String','Last Saved Image',...
                'HorizontalAlignment','center','Units','normalized','Position',[.55 .9 .5 .1],'Callback',@(src,event)setEntryValve(uscopeGUI));

            uscopeGUI.currentImFig = axes('Parent',uscopeGUI.imagesPanel,'Position',[.01 .05 .5 .9]);
            imshow(zeros(512),'Parent',uscopeGUI.currentImFig);
            uscopeGUI.recentlySavedImFig = axes('Parent',uscopeGUI.imagesPanel,'Position',[.5 .05 .5 .9]);
            imshow(zeros(512),'Parent',uscopeGUI.recentlySavedImFig);

            set(uscopeGUI.stopExpButton, 'Enable', 'Off');  

        end
        
        function setBinning(uscopeGUI)
            binningString=get(uscopeGUI.setBinningPopup,'String');
            binningSelected=get(uscopeGUI.setBinningPopup,'Value');
            uscopeGUI.wormscope.setBinning(str2double(binningString{binningSelected}));
        end
        
        function setExposTime(uscopeGUI)
            exposTime=get(uscopeGUI.setExposTimeText,'String');
            uscopeGUI.wormscope.setExposTime(str2double(exposTime)/100);
        end
        
        function setLoadDelayBeforeFlush(uscopeGUI)
            thresh=get(uscopeGUI.setFlushTimeText,'String');
            uscopeGUI.wormscope.delayTimeBeforeLoadFlush=(str2double(thresh));
        end
        
        function setFlushTime(uscopeGUI)
            thresh=get(uscopeGUI.setFlushTimeText,'String');
            uscopeGUI.wormscope.releaseDelay=(str2double(thresh));
        end
        
        function setAutoLoadTresh(uscopeGUI)
            thresh=get(uscopeGUI.setAutoLoadThreshText,'String');
            uscopeGUI.wormscope.autoLoadImCVThresh=(str2double(thresh));
        end
        
        function setEntryValve(uscopeGUI)
            valve=get(uscopeGUI.setEntryValveText,'String');
            uscopeGUI.wormscope.sValve.entry=str2double(valve);
        end
        
        function setPosValve(uscopeGUI)
            valve=get(uscopeGUI.setPosValveText,'String');
            uscopeGUI.wormscope.sValve.position=str2double(valve);
        end
        
        function setExit1Valve(uscopeGUI)
            valve=get(uscopeGUI.setExit1ValveText,'String');
            uscopeGUI.wormscope.sValve.exit1=str2double(valve);
        end
        
        function setExit2Valve(uscopeGUI)
            valve=get(uscopeGUI.setExit2ValveText,'String');
            uscopeGUI.wormscope.sValve.exit2=str2double(valve);
        end
        
        function setFlushValve(uscopeGUI)
            valve=get(uscopeGUI.setFlushValveText,'String');
            uscopeGUI.wormscope.sValve.flush=str2double(valve);
        end
        
        function setInjectionValve(uscopeGUI)
            valve=get(uscopeGUI.setInjectionValveText,'String');
            uscopeGUI.wormscope.sValve.injection=str2double(valve);
        end
        
        function wormExit2(uscopeGUI)
            uscopeGUI.wormscope.wormExit2ValveSequence;
        end
           
        function wormExit1(uscopeGUI)
            uscopeGUI.wormscope.wormExit1ValveSequence;
        end
        
        function wormPresentValve(uscopeGUI)
            uscopeGUI.wormscope.wormPresentValveSequence;
        end
        
        function wormLoadingValve(uscopeGUI)
            uscopeGUI.wormscope.wormLoadingValveSequence;
        end
        
        function runAutoImaging(uscopeGUI)
            set(uscopeGUI.runExpButton, 'Enable', 'Off');
            set(uscopeGUI.stopExpButton, 'Enable', 'On');
            
            uscopeGUI.setAutoLoadTresh;
            uscopeGUI.setBinning;
            uscopeGUI.setEntryValve;
            uscopeGUI.setExit1Valve;
            uscopeGUI.setExit2Valve;
            uscopeGUI.setExpName;
            uscopeGUI.setExposTime;
            uscopeGUI.setFlushTime;
            uscopeGUI.setFlushValve;
            uscopeGUI.setInjectionValve;
            uscopeGUI.setLoadDelayBeforeFlush;
            uscopeGUI.setPosValve;
            uscopeGUI.wormscope.runAutoWormImaging;
        end
        
        function stopExp(uscopeGUI)
            uscopeGUI.wormscope.abortRun=true;
            fclose(uscopeGUI.wormscope.logFile);
            set(uscopeGUI.runExpButton, 'Enable', 'On');
            set(uscopeGUI.stopExpButton, 'Enable', 'Off');
        end
        
        function selectRootFolder(uscopeGUI)
            uscopeGUI.wormscope.setAcqFolder;
            set(uscopeGUI.rootFolderText,'string',uscopeGUI.wormscope.acqFolder);
        end
        
        function setRootFolder(uscopeGUI)
            uscopeGUI.wormscope.acqFolder=get(uscopeGUI.rootFolderText,'String');
        end
        
        function setExpName(uscopeGUI)
            uscopeGUI.wormscope.originalExpName=get(uscopeGUI.expNameText,'String');
            uscopeGUI.wormscope.expName=uscopeGUI.wormscope.originalExpName;
        end

        
        
    end
end