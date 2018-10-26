function wormPresentValveSequence(wormscope)
% 2011 Georgia Tech
% Matthew Crane
% Description: 	This operates the correct valve sequence in order to trap
% the loaded worm for imaging.
%
% Parameters: Valve - a struct containing the appropriate ID numbers for
% each of the solenoids controlled by the DAQ. 
%
% Returns: Null

wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.entry,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.position,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.exit1,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.exit2,wormscope.sValve.powered);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.injection,wormscope.sValve.nopower);
wormscope.cSolenoidValves.changeRelayState(wormscope.sValve.flush,wormscope.sValve.nopower);
