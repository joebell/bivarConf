%
% bivariateKDE.m
% 
% Computes an estimated PDF by smoothing with a gaussian kernel. By default
% chooses an optimal bandwidth (using Silverman's rule). Bandwidth can be 
% scaled up or down from this optimal by a factor ScaleBandwidth.
%
%%
function P = bivariateKDE(points, Xlist, Ylist, varargin)

    scaleBandwidth = 1;
    for argN = 1:2:(nargin-3)
        if strcmp(varargin{argN},'ScaleBandwidth')
                scaleBandwidth = varargin{argN+1};
        end
    end
        
    [Xgrid,Ygrid] = meshgrid(Xlist,Ylist);
    
    % Estimate bandwidth with Silverman's rule
    sig = mad(points,1,1) / 0.6745;
    N = size(points,1);  d = size(points,2);
    bw = sig * (4/((d+2)*N))^(1/(d+4)) .* scaleBandwidth;
    
    % Calculate the KDE
    [P,xi] = ksdensity(points,[Xgrid(:),Ygrid(:)],'Bandwidth', bw);
    
    % Reshape and normalize
    P = reshape(P,length(Ylist), length(Xlist));
    P = P./sum(P(:));
end