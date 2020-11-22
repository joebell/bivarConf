%
% Calculates a list of bin edges from a list of centers.
%
function binEdges = centersToEdges(binCenters)
    eCtrs = [binCenters(1) - (binCenters(2) - binCenters(1));...
             binCenters(:);...
             binCenters(end) + (binCenters(end) - binCenters(end-1))];
    binEdges = eCtrs(1:(end-1)) + diff(eCtrs)/2;
end