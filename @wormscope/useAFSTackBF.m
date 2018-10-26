function useAFSTackBF(scope)
% this function acquires the images needed (single slice or stack if
% needed)



p=1;
keepPFSON=false;
nSlices=scope.loopParams(scope.currLoop).zSliceN(scope.currCh);
sliceInterval=scope.loopParams(scope.currLoop).zSliceStep(scope.currCh);
chName=scope.loopParams(scope.currLoop).channels(scope.currCh);
startPos=scope.loopParams(scope.currLoop).zOffset(scope.currCh);
filename=strcat(scope.acqFolder, filesep, scope.expName, filesep, 'Pos', num2str(scope.currPos), filesep, ...
    scope.expName,'_',sprintf('%06d',scope.currFrame),'_',chName);

isBF=true;

if scope.loopParams(scope.currLoop).acqStack(scope.currCh) %this is a stack acquisition
    %make sure the PFS or other focus device is off
    zStep=-floor(nSlices/2)+[0:nSlices-1];
    zStep=zStep*2*sliceInterval;
    [b index]=sort(abs(zStep));
    slicePosition=startPos-((nSlices-1)*p*sliceInterval)/2;
    

    for z=1:nSlices  %start of z sectioning loop
        distToAFSlice=pdist2(scope.afRelLoc',slicePosition);
        [v afLoc]=min(distToAFSlice);
        img=scope.afStack(:,:,afLoc);
        
        %need to record the maximum measured value to return
        %This is done before any correction for changes in exposure time
        
        %                     img2=reshape(img2,[scope.imHeight,scope.imWidth]);
            sliceFileName=strcat(filename,'_',sprintf('%03d',z),'.tif');
            img2=img;
        
            slicePosition=startPos-((nSlices-1)*p*sliceInterval)/2+(p*((z)*sliceInterval));
        if isBF
            img2=double(img2);
            img2=img2-min(img2(:));
            img2=img2/max(img2(:))*255;
            img2=uint8(img2);
            imwrite(img2,char(sliceFileName),'jpg','Quality',85);%,,'CompressionRatio',10);toc
        else
            imwrite(img2,char(sliceFileName),'tif');%,,'CompressionRatio',10);toc
        end
        %                     pause(.1)
    end
    
else %single section acquisition
    distToAFSlice=pdist2(scope.afRelLoc',0);
    [v afLoc]=min(distToAFSlice);
    img=scope.afStack(:,:,afLoc);

    img2=img;
    sliceFileName=strcat(filename,'_',sprintf('%03d'),'.tif');
    if isBF
        img2=double(img2);
        img2=img2-min(img2(:));
        img2=img2/max(img2(:))*255;
        img2=uint8(img2);
        imwrite(img2,char(sliceFileName),'jpg','Quality',85);%,,'CompressionRatio',10);toc
    else
        imwrite(img2,char(sliceFileName),'tif');
    end
end

end