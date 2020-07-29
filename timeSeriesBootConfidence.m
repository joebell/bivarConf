%% timeSeriesBootConfidence.m
%
%  Draw a confidence region for a bootstrapped time series.
%
%  x           - Position of the points in the X axis
%  bootY       - Bootstrapped time series estimates, matrix of size [Nboots, length(x)]
%  alpha       - Confidence interval to draw
%  varargin    - Optional plotting arguments passed to patch()
%
%  Returns: h  - Handle to a patch object
%%
function h = timeSeriesBootConfidence( x, bootY, alpha, varargin)

    x = x(:);
    nRows = size(bootY, 1);
    Ysorted = sort(bootY,1,'ascend');
    Ybottom = Ysorted(round((alpha/2)*nRows),:); 
    Ybottom = Ybottom(:);
    Ytop = Ysorted(round((1 - alpha/2)*nRows),:); 
    Ytop = Ytop(:);

    h = patch([x(1:end);x(end:-1:1);x(1)],[Ybottom(1:end);Ytop(end:-1:1);Ybottom(1)],'b',...
            'EdgeColor','none','FaceAlpha',0.3, varargin{:});
end