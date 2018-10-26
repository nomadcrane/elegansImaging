function visitPosUpdateAF(scope,posNum)
global mmc;
if nargin>1
    scope.currPos=posNum;
end

scope.visitXY(scope.posXYZ(scope.currPos,1),scope.posXYZ(scope.currPos,2));
if ~scope.afOn
    scope.visitZ(scope.posXYZ(scope.currPos,3));
end
if any(diff(scope.posOffset))
    scope.correctFocusOffset();
else
    scope.correctFocusOffset;
end
end