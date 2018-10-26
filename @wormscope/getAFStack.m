function [stack, zloc]=getAFStack(scope)
global mmc;
sectDevice=scope.zDrive;
nSlices=scope.afParams.umRange/scope.afParams.umSteps;
sliceInterval=scope.afParams.umSteps;
startPos=scope.posXYZ(scope.currPos,3);

zStep=-floor(nSlices/2)+[0:nSlices-1];
zStep=zStep*2*sliceInterval;
[b index]=sort(abs(zStep));
p=1;
slicePosition=startPos-((nSlices-1)*p*sliceInterval)/2;
mmc.setPosition(sectDevice,slicePosition);
if strcmp(scope.name,'Zeiss')
    pause(.3);
    pdur=.3;
else
    pdur=.04;
end
pause(.1);
zloc=slicePosition;
for z=1:nSlices  %start of z sectioning loop
    
    mmc.snapImage();
    img=mmc.getImage;
    
    img2=typecast(img,'uint16');
    img2=reshape(img2,[scope.imHeight,scope.imWidth]);
    stack(:,:,z)=img2;
    if z<nSlices
        slicePosition=startPos-((nSlices-1)*p*sliceInterval)/2+(p*((z)*sliceInterval));
        zloc(z+1)=slicePosition;
        mmc.setPosition(sectDevice,slicePosition);
        pause(pdur);
    end
end
end