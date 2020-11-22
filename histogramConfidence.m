%%
% histogramConfidence.m
%
% Uses gaussian smoothing of a histogram to find a confidence region. 
% 
% varargin{:} - Specifies optional arguments to autogridBivariate.m
%
%%
function M = histogramConfidence(points, alpha, varargin)
    [Xedges, Yedges] = autogridBivariate(points, 'BinCenters', false, varargin{:});
    P = smoothHistogramDensityEstimate(points, Xedges, Yedges, varargin{:});
    Xctrs = edgesToCenters(Xedges); Yctrs = edgesToCenters(Yedges);
    % M = contourBivariateDistribution(P, binCenters{1}, binCenters{2}, alpha);
    M = calibratedContour(P, Xctrs, Yctrs, alpha, points);
end