function turnOnAF(scope)
global mmc
switch scope.afMethod
    case 'PFS'
        if ~scope.afOn
            mmc.setProperty('TIPFSStatus','State','On');
            pause(.2);
%             mmc.waitForDevice('TIPFSStatus');
        end
    case 'software'
end
scope.afOn=true;
end