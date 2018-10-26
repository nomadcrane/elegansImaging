function wormExit1ValveSequence(wormscope)
% 2017 
% Matthew Crane
% Description: 	This operates the correct valve sequence in order to
% release a worm quickly through exit1
%
%
% Returns: Null

wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.entry,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.position,wormscope.sValve.nopower);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.exit1,wormscope.sValve.nopower);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.exit2,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.injection,wormscope.sValve.powered);

pause(.1);

wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.flush,wormscope.sValve.powered);

pause(wormscope.releaseDelay)

wormscope.wormLoadingValveSequence;



