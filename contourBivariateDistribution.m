%
% contourBivariateDistribution.m
%
% Takes a probability distribution P sampled on a grid Xlist x Ylist and 
% draws a contour line at the level (1 - alpha).
%
%%
function M = contourBivariateDistribution(P, Xlist, Ylist, alpha)
    % Ensure the distribution sums to one
    if abs(sum(P(:)) - 1) > 10^-3
        error(sprintf('Input distribution does not sum to one: %0.3f',sum(P(:))));
    end
    sP = sort(P(:),'descend');
    cP = cumsum(sP);
    level = sP(find(cP > (1 - alpha),1));
    
    M = contourc(Xlist,Ylist,P,[level level]);
end