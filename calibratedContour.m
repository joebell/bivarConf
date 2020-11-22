%
% calibratedContour.m
%
% Draws a contour line on P as in contourBivariateDistribution.m but then 
% adjusts the level alpha such that (1 - alpha) of sample points are contained
% in the contour. This calculates multiple contours and checks whether points 
% are inside them, so it runs a little slower, but produces much less biased 
% coverage especially with high kernel bandwidths.
%
%%
function M = calibratedContour(P, Xlist, Ylist, alpha, points)
    % Ensure the distribution sums to one
    if abs(sum(P(:)) - 1) > 10^-3
        error(sprintf('Input distribution does not sum to one: %0.3f',sum(P(:))));
    end
    
    sP = sort(P(:),'descend');
    cP = cumsum(sP);
    
    % Search in 2 stages, coarse first
    pointsPerRound = 16;
    alphaList = linspace(2/size(points,1),1-2/size(points,1),pointsPerRound);
    for alphaN = 1:length(alphaList)
        tryAlpha = alphaList(alphaN);

        levels(alphaN) = sP(find(cP > (1 - tryAlpha),1));
        M = contourc(Xlist,Ylist,P,[levels(alphaN) levels(alphaN)]);
        poly = contourToPolygon(M);
        if size(poly,1) > 0
            coverage(alphaN) = nnz(inpolygon(points(:,1),points(:,2),poly(:,1),poly(:,2)))/size(points,1);
        else
            coverage(alphaN) = 0;
        end
    end
    [~, ix] = min(abs((1 - coverage - alpha)));
    % Now do a fine search
    alphaList = linspace(alphaList(max([ix-1,1])),alphaList(min([ix+1,pointsPerRound])),pointsPerRound);
    for alphaN = 1:length(alphaList)
        tryAlpha = alphaList(alphaN);

        levels(alphaN) = sP(find(cP > (1 - tryAlpha),1));
        M = contourc(Xlist,Ylist,P,[levels(alphaN) levels(alphaN)]);
        poly = contourToPolygon(M);
        if size(poly,1) > 0
            coverage(alphaN) = nnz(inpolygon(points(:,1),points(:,2),poly(:,1),poly(:,2)))/size(points,1);
        else
            coverage(alphaN) = 0;
        end
    end
    [~, ix] = min(abs((1 - coverage - alpha)));

    M = contourc(Xlist,Ylist,P,[levels(ix) levels(ix)]); hold on;       
end