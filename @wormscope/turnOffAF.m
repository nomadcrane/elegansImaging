function turnOffAF(scope)
global mmc
switch scope.afMethod
    case 'PFS'
        if scope.afOn
            mmc.setProperty('TIPFSStatus','State','Off');
        end
    case 'software'
end
scope.afOn=false;
end