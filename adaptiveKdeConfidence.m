%%
% adaptiveKdeConfidence.m
%
% Uses gaussian kernel density estimation to find a confidence region. 
% 
% varargin{:} - Specifies optional arguments to autogridBivariate.m
%
%%
function M = adaptiveKdeConfidence(points, alpha, varargin)
    [x, y] = autogridBivariate(points, 'BinCenters', true, varargin{:});
    P = adaptiveBivariateKDE(points,x,y,varargin{:}); 
    % M = contourBivariateDistribution(P, x, y, alpha);
    M = calibratedContour(P, x, y, alpha, points);
end