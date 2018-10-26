function wormSpeedLoadingValveSequence(wormscope)
% 2017 
% Matthew Crane
% Description: 	This operates the correct valve sequence in order to trap
% a worm quickly 
%
%
% Returns: Null

wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.entry,wormscope.sValve.nopower);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.position,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.exit1,wormscope.sValve.nopower);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.exit2,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.injection,wormscope.sValve.powered);

wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.flush,wormscope.sValve.nopower);

pause(wormscope.speedLoadDelay)

wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.position,wormscope.sValve.powered);


