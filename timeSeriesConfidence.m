%% timeSeriesConfidence.m
%
%  Draw a confidence region for a bootstrapped time series.
%
%  x           - Position of the points in the X axis
%  ci          - Confidence intervals, row 1 is lower bound, row 2 is upper bound
%  varargin    - Optional plotting arguments passed to patch()
%
%  Returns: h  - Handle to a patch object
%%
function h = timeSeriesConfidence(x, ci, varargin)

    x = x(:);
    Ybottom = ci(1,:)'; 
    Ytop = ci(2,:)';

    h = patch([x(1:end);x(end:-1:1);x(1)],[Ybottom(1:end);Ytop(end:-1:1);Ybottom(1)],'b',...
            'EdgeColor','none','FaceAlpha',0.3, varargin{:});
end