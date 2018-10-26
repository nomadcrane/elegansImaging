function tileXY(scope)
global mmc
correctLens=false;
while ~correctLens
    lens=inputdlg('Enter lens magnification (10, 40 (Robin only), 60 or 100):','Tile creation: enter magnification',1,{'60'});
    if any(strcmp(lens{:},{'40', '60','100','10'}));
        correctLens=true;
    end
end
defaults={'10','10','',''};
switch lens{:}
    case '10'
        defaults{3}='824';
        defaults{4}='824';
    case '40'
        defaults{1}='15';
        defaults{2}='5';
        defaults{3}='155'; %167 to be touching
        defaults{4}='-200'; %220 to be adjacent
    case '60'
        defaults{3}='137';
        defaults{4}='137';
    case '100'
        defaults{3}='82.4';
        defaults{4}='82.4';
end
defaults{5}='pos';
answers=inputdlg({'Number of rows (y)','Number of columns(x)','Space between rows (microns)','Space between columns (microns)','Name for this group'},'Tile creation: define dimensions',1,defaults);

nRows=str2double(answers{1});
nColumns=str2double(answers{2});
rowSpacing=str2double(answers{3});
colSpacing=str2double(answers{4});

scope.currPos=0;
scope.posXYZ=[];scope.posOffset=[];
startX=mmc.getXPosition(scope.xyDrive);
startY=mmc.getYPosition(scope.xyDrive);
startZ=mmc.getPosition(scope.zDrive);
switch scope.afMethod
    case 'PFS'
        startOffset=str2num(mmc.getProperty('TIPFSOffset','Position'));
    case 'software'
        startOffset=NaN;
end

for row=1:nRows
    for col=1:nColumns
        %Generate a default name and make sure this name hasn't already been taken
        scope.currPos=scope.currPos+1;
        scope.posXYZ(scope.currPos,1)=(col-1)*colSpacing+startX;
        scope.posXYZ(scope.currPos,2)=(row-1)*rowSpacing+startY;
        %Calculate z position based on how far away from the start position
        %it is in x and y and the recorded slopes.
%         xDistance=(col-1)*colSpacing;
%         zDisplacementX=xDistance*xSlope;     
%         yDistance=(row-1)*rowSpacing;
%         zDisplacementY=yDistance*ySlope;      
%         xyTiles(number,3)=startZ+zDisplacementX+zDisplacementY;
        scope.posXYZ(scope.currPos,3)=startZ;
        scope.posOffset(scope.currPos)=startOffset;
    end
end

