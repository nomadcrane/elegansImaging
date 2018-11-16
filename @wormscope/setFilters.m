function setFilters(scope)
%Change the microscope to the appropriate color/filter, and set the power
%for the LED. The led power is not going to be a universal command, so it
%will likely need to be modified for your specific setup.

global mmc
chName=scope.loopParams(scope.currLoop).channels{scope.currCh};
expos=scope.loopParams(scope.currLoop).exposureTime(scope.currCh);
mmc.setConfig('Channel', chName);
mmc.setExposure(expos);
mmc.waitForConfig('Channel', chName);

% set the light intensity for the fluorescence for this channel
if isfield(scope.loopParams(scope.currLoop),'power')
    if isempty(scope.loopParams(scope.currLoop).power)
        flPower=25;
    else
        flPower=scope.loopParams(scope.currLoop).power(scope.currCh);
    end
else
    flPower=25;
end

% b/c it can only accept these numbers for some silly reason
if flPower>50
    flPower=100;
elseif flPower>25
    flPower=50;
elseif flPower>12
    flPower =25;
elseif flPower>0
    flPower=12;
end
mmc.setProperty('XCite-120PC','Lamp-Intensity', flPower);


end