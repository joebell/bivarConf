%
% Calculates a list of bin centers from a list of bin edges.
%
function binCenters = edgesToCenters(binEdges)

    binCenters = (binEdges(1:(end-1)) + binEdges(2:end))/2;
    
end