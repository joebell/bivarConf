%
% smoothHistogramDensityEstimate.m
%
% Function to calculate and smooth a histogram with given edges.
%
%%
function P = smoothHistogramDensityEstimate(points, Xedges, Yedges, varargin)
    smoothBins = 0;
    for argN = 1:2:(nargin-3)
        if strcmp(varargin{argN},'SmoothBins')
            smoothBins = varargin{argN+1};
        end
    end
    
    N = histcounts2(points(:,1),points(:,2),Xedges,Yedges); 
    N = smoothHist(N, smoothBins);
    P = N'./(sum(N(:)));
end