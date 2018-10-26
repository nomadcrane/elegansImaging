function wormLoading(wormscope)
% 2017 
% Matthew Crane
% Description: 	This operates the correct valve sequence in order to
% release a worm quickly through exit1
%
%
% Returns: Null

wormscope.wormLoadingValveSequence();
loadStartT=tic;
flush=0;
while true
    
    if wormscope.abortRun
        break;
    end
    mmc.snapImage();
    im=mmc.getImage;
    img2=typecast(im,'uint16');
    img2=reshape(img2,[wormscope.imHeight,wormscope.imWidth]);
    wormscope.currentIm=img2;
    
    im_mean=mean2(im(:));
    im_std=std2(double(im(:)));
    imCV=im_std/im_mean;
    
    if (imCV > wormscope.autoLoadImCVThresh)
        wormscope.wormPresentValveSequence;
        pause(.1);
        im=mmc.getImage;
        im_mean=mean2(im(:));
        im_std=std2(double(im(:)));
        imCV=im_std/im_mean;
        img2=typecast(im,'uint16');
        img2=reshape(img2,[wormscope.imHeight,wormscope.imWidth]);
        wormscope.currentIm=img2;

        
        if (imCV > wormscope.autoLoadImCVThresh)
            wormscope.wormPresentValveSequence;
            break;
        else
            wormscope.wormExit1ValveSequence();
            loadStartT=tic;
        end
    elseif toc(loadStartT)>wormscope.delayTimeBeforeLoadFlush
        wormscope.wormExit1ValveSequence();
        loadStartT=tic;
        flush=flush+1;
    end
%     if flush>CWaitParameters.FlushTimesBeforeText
%         sendmail(CWaitParameters.EmailAddress,'Clog','Clogged or need more worms');
%         flush=0;
%     end
end


