%%
%   XYpointConfidence.m
%
%   Function for drawing confidence intervals of repeated measures of points.
%
%   ptIn should be an array of points with shape [nTrials, 2]
%
%%
function XYpointConfidence(ptIn, nBoots, nBins, alpha, varargin)

    nPts = size(ptIn,1);

    bootPts = zeros(nBoots,nPts,2);
    bootAvgs = zeros(nBoots,2);
    for bootN = 1:nBoots
        bootPts(bootN,:,1) = ptIn(randi(nPts,nPts,1),1);
        bootPts(bootN,:,2) = ptIn(randi(nPts,nPts,1),2);
    end
    bootAvgs = squeeze(mean(bootPts,2));
    
    [N,binCenters] = hist3(bootAvgs,[nBins,nBins]);
    P = N/nBoots;
    sP = sort(P(:),'descend');
    cP = cumsum(sP);
    level = sP(find(cP > (1 - alpha),1));
    M = contourc(binCenters{1},binCenters{2},P,[level level]);
    g = plotContour(M,'FaceColor','blue','FaceAlpha',0.5,'EdgeColor','None',...
        varargin{:});

end
% Plots contours from contour matrix using polyshapes. This replaces the draw
% functionality of contourf, so that patch properties can be set more
% flexibly.
function h = plotContour(M, varargin)
    stIX = 1;
    enIX = stIX + M(2, stIX);
    while (stIX < size(M,2))
        enIX = stIX + M(2,stIX);
        M(:,stIX) = NaN;
        stIX = enIX + 1;
    end
    warning('off');
    p = polyshape(M(1,:),M(2,:),'Simplify',true);
    warning('on');
    h = plot(p,varargin{:});
end    
    
    
