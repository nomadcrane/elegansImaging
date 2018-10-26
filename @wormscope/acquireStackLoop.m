function acquireStackLoop(scope)
% this function acquires the images needed (single slice or stack if
% needed)

if strcmp(scope.name,'Zeiss')
    pause(.3);
    pdur=.3;
else
    pdur=.01;
end


global mmc;


p=1;
keepPFSON=false;
sectDevice=scope.zDrive;
nSlices=scope.loopParams(scope.currLoop).zSliceN(scope.currCh);
sliceInterval=scope.loopParams(scope.currLoop).zSliceStep(scope.currCh);
startPos=scope.posXYZ(scope.currPos,3);
chName=scope.loopParams(scope.currLoop).channels(scope.currCh);
startPos=startPos+scope.loopParams(scope.currLoop).zOffset(scope.currCh);
filename=strcat(scope.acqFolder, filesep, scope.expName, filesep, 'Pos', num2str(scope.currPos), filesep, ...
    scope.expName,'_',sprintf('%06d',scope.currFrame),'_',chName);

isBF=false;
switch scope.loopParams(scope.currLoop).channels{scope.currCh};
    case 'BF'
        isBF=true;
    case 'DIC'
        isBF=true;
end

if scope.loopParams(scope.currLoop).acqStack(scope.currCh) %this is a stack acquisition
    %make sure the PFS or other focus device is off
    if ~keepPFSON
        scope.turnOffAF
    end
    zStep=-floor(nSlices/2)+[0:nSlices-1];
    zStep=zStep*2*sliceInterval;
    [b index]=sort(abs(zStep));
    slicePosition=startPos-((nSlices-1)*p*sliceInterval)/2;
    mmc.setPosition(sectDevice,slicePosition);
    pause(pdur);
    for z=1:nSlices  %start of z sectioning loop
        if keepPFSON
            zMov=zStep(index(z));
            slicePosition=startPos+zMov;
            pauseDur=.005;
        else
            pauseDur=.01;
        end
        
        mmc.snapImage();
        if keepPFSON
            mmc.setPosition(sectDevice,startPos);
            if z==1
                pause(.02);
            end
        end
        img=mmc.getImage;
        
        img2=typecast(img,'uint16');
        img2=reshape(img2,[scope.imHeight,scope.imWidth]);
        
        %                     img2=reshape(img2,[scope.imHeight,scope.imWidth]);
        if keepPFSON
            sliceFileName=strcat(filename,'_',sprintf('%03d',index(z)),'.tif');
        else
            sliceFileName=strcat(filename,'_',sprintf('%03d',z),'.tif');
        end
        if false
            img2=flipud(img2);
        end
        if keepPFSON
            stack(:,:,index(z))=img2;
        else
            stack(:,:,z)=img2;
        end
        if z<nSlices
            slicePosition=startPos-((nSlices-1)*p*sliceInterval)/2+(p*((z)*sliceInterval));
            mmc.setPosition(sectDevice,slicePosition);
            pause(pdur);
        end
        tic
        if isBF
            img2=double(img2);
            img2=img2-min(img2(:));
            img2=img2/max(img2(:))*255;
            img2=uint8(img2);
            
            imwrite(img2,char(sliceFileName),'jpg','Quality',85);%,,'CompressionRatio',10);toc
        else
            imwrite(img2,char(sliceFileName),'tif');%,,'CompressionRatio',10);toc
%             imwrite(img2,char(sliceFileName),'jp2','CompressionRatio',10);
        end
        %                     pause(.1)
    end
    
else %single section acquisition
    if startPos~=scope.posXYZ(scope.currPos,3)
        scope.turnOffAF
        mmc.setPosition(sectDevice,startPos);
    end
    
    mmc.snapImage();
    img=mmc.getImage;
    img2=typecast(img,'uint16');
    img2=reshape(img2,[scope.imHeight,scope.imWidth]);
    stack(:,:,1)=img2;
    sliceFileName=strcat(filename,'_',sprintf('%03d'),'.tif');
    if false
        img2=flipud(img2);
    end
    if isBF
        img2=double(img2);
        img2=img2-min(img2(:));
        img2=img2/max(img2(:))*255;
        img2=uint8(img2);
        imwrite(img2,char(sliceFileName),'jpg');%,,'CompressionRatio',10);toc
    else
        imwrite(img2,char(sliceFileName),'tif');
    end
end

%Restore z position
startPos=scope.posXYZ(scope.currPos,3);
mmc.setPosition(sectDevice,startPos);
pause(pdur);
end