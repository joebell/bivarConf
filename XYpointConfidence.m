%%
%   XYpointConfidence.m
%
%   Function for drawing confidence intervals of repeated measures of points.
%
%   ptIn should be an array of points with shape [nTrials, 2]
%
%%
function XYpointConfidence(ptIn, nBoots, alpha)

    nPts = size(ptIn,1);
    meanVal = mean(ptIn,1);
    plot(meanVal(1), meanVal(2),'r.');

    bootPts = zeros(nBoots,nPts,2);
    bootAvgs = zeros(nBoots,2);
    for bootN = 1:nBoots
        bootPts(bootN,:,1) = ptIn(randi(nPts,nPts,1),1);
        bootPts(bootN,:,2) = ptIn(randi(nPts,nPts,1),2);
    end
    bootAvgs = squeeze(mean(bootPts,2));
    
    [N,binCenters] = hist3(bootAvgs,[32,32]);
    P = N/nBoots;
    sP = sort(P(:),'descend');
    cP = cumsum(sP);
    level = sP(find(cP > alpha,1));
    [M, h] = contourf(binCenters{1},binCenters{2},P,[level level]);
    %h.Visible = false;
    %h = patch(M(1,2:end),M(2,2:end),'red','FaceAlpha',0.5,'EdgeColor','none','FaceColor','r');

end
