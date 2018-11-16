classdef solenoidValveGUI<handle
    % solenoidValveGUI
    %
    % a simple GUI that shows the status of all solenoid valves that can be
    % actuated and controlled by the computer. By default, it assumes that
    % there are 8 valves given the constraints of the physcial control box
    % This class is called by the wormscopeGUI to control each valve and
    % provides and instantaneuous visual feedback of the valve status.
    %
    properties
        figure = [];
        
        relay0Button
        relay1Button
        relay2Button
        relay3Button
        relay4Button
        relay5Button
        relay6Button
        relay7Button
        
        currentGUI;
                
        relayStates=[0 0 0 0 0 0 0 0];
        solenoidPort
        
        nRelays
    end
    
    properties (SetObservable)
        ActiveContourButtonState = 1;
        
    end % properties
    methods
        function cSolenoidValveGUI=solenoidValveGUI(comPort)
            
            if nargin<1
                comPort='COM4';
            end
            
            scrsz = get(0,'ScreenSize');
            cSolenoidValveGUI.figure=figure('MenuBar','none','CloseRequestFcn',@(src,event)figClose(cSolenoidValveGUI),'Position',[scrsz(3)/3 scrsz(4)/3 scrsz(3)/6 scrsz(4)/8]);
            
            nValves=4;
            cSolenoidValveGUI.relay0Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 0','BackgroundColor','red',...
                'Units','normalized','Position',[.025 .5 .245 .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,0));
            cSolenoidValveGUI.relay1Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 1','BackgroundColor','red',...
                'Units','normalized','Position',[.275 .5 .245  .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,1));
            cSolenoidValveGUI.relay2Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 2','BackgroundColor','red',...
                'Units','normalized','Position',[.525 .5 .245  .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,2));
            cSolenoidValveGUI.relay3Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 3','BackgroundColor','red',...
                'Units','normalized','Position',[.775 .5 .245  .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,3));
            cSolenoidValveGUI.relay4Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 4','BackgroundColor','red',...
                'Units','normalized','Position',[.025 .0 .245 .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,4));
            cSolenoidValveGUI.relay5Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 5','BackgroundColor','red',...
                'Units','normalized','Position',[.275 .0 .245  .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,5));
            cSolenoidValveGUI.relay6Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 6','BackgroundColor','red',...
                'Units','normalized','Position',[.525 .0 .245  .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,6));
            cSolenoidValveGUI.relay7Button = uicontrol(cSolenoidValveGUI.figure,'Style','pushbutton','String','Relay 7','BackgroundColor','red',...
                'Units','normalized','Position',[.775 .0 .245  .5],'Callback',@(src,event)toggleRelay(cSolenoidValveGUI,7));

            cSolenoidValveGUI.solenoidPort = serial(comPort,'baudrate',9600,'Terminator','CR');
            fopen(cSolenoidValveGUI.solenoidPort);
            
            fprintf(cSolenoidValveGUI.solenoidPort,'reset');
        end
        
        % Other functions
        function figClose(cSolenoidValveGUI)
            % Close request function
            % to display a question dialog box
            selection = questdlg('Close This Figure?',...
                'Close Request Function',...
                'Yes','No','Yes');
            switch selection,
                case 'Yes',
                    fclose(cSolenoidValveGUI.solenoidPort);
                    delete(gcf)
                case 'No'
                    return
            end
        end
        
        function toggleRelay(cSolenoidValveGUI,relayNum)
            valveState=cSolenoidValveGUI.relayStates(relayNum+1);
            if valveState
                cmd='off';
                cSolenoidValveGUI.relayStates(relayNum+1)=0;
                colorRelay='red';
            else
                cmd='on';
                cSolenoidValveGUI.relayStates(relayNum+1)=1;
                colorRelay='green';
            end
            fprintf(cSolenoidValveGUI.solenoidPort,['relay ' cmd ' ' num2str(relayNum)]);
            pause(.001);
            switch relayNum
                case 0
                    set(cSolenoidValveGUI.relay0Button,'BackgroundColor',colorRelay)
                case 1
                    set(cSolenoidValveGUI.relay1Button,'BackgroundColor',colorRelay)
                case 2
                    set(cSolenoidValveGUI.relay2Button,'BackgroundColor',colorRelay)
                case 3
                    set(cSolenoidValveGUI.relay3Button,'BackgroundColor',colorRelay)
                case 4
                    set(cSolenoidValveGUI.relay4Button,'BackgroundColor',colorRelay)
                case 5
                    set(cSolenoidValveGUI.relay5Button,'BackgroundColor',colorRelay)
                case 6
                    set(cSolenoidValveGUI.relay6Button,'BackgroundColor',colorRelay)
                case 7
                    set(cSolenoidValveGUI.relay7Button,'BackgroundColor',colorRelay)
            end
            drawnow;
        end
        
        function changeRelayState(cSolenoidValveGUI,relayNum, newState)
            %newState should be binary
            if newState
                cmd='on';
                cSolenoidValveGUI.relayStates(relayNum+1)=1;
                colorRelay='green';
            else
                cmd='off';
                cSolenoidValveGUI.relayStates(relayNum+1)=0;
                colorRelay='red';
            end
            fprintf(cSolenoidValveGUI.solenoidPort,['relay ' cmd ' ' num2str(relayNum)]);
            switch relayNum
                case 0
                    set(cSolenoidValveGUI.relay0Button,'BackgroundColor',colorRelay)
                case 1
                    set(cSolenoidValveGUI.relay1Button,'BackgroundColor',colorRelay)
                case 2
                    set(cSolenoidValveGUI.relay2Button,'BackgroundColor',colorRelay)
                case 3
                    set(cSolenoidValveGUI.relay3Button,'BackgroundColor',colorRelay)
                case 4
                    set(cSolenoidValveGUI.relay4Button,'BackgroundColor',colorRelay)
                case 5
                    set(cSolenoidValveGUI.relay5Button,'BackgroundColor',colorRelay)
                case 6
                    set(cSolenoidValveGUI.relay6Button,'BackgroundColor',colorRelay)
                case 7
                    set(cSolenoidValveGUI.relay7Button,'BackgroundColor',colorRelay)
            end
            drawnow;
        end
    end
end
