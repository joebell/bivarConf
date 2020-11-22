%
% autogridBivariate.m
%
% Function for automatically binning or grid-covering bivariate distributions with a uniform grid.
% 
%     points - [N,2] matrix of points to grid over.
%
%     Xlist, Ylist - List of bin edges or centers.
%
% By default returns edges of an optimal binning (in the MSE sense) for bivariate gaussian distribution, 
% based on the extent and distribution of the data. Beyond this parameters can be adjusted as Name/Value 
% pairs.
%
% 'Resolution' - [1,2] matrix of bin spacing in X,Y.
% 'Overspan'   - (default: 1) Positive scalar, length of coverage beyond distribution 
%                 relative to maximum span of data
% 'Ngrid'      - Number of points to include (will return N+1 edges)
% 'BinCenters' - (default: false) If true will return bin center points instead of bin edges.
% 'Upsample'   - Factor to increase Nbins beyond current settings
%
%%
function [Xlist, Ylist] = autogridBivariate(points, varargin)



    nPoints = size(points,1);
    Xmid = (max(points(:,1)) + min(points(:,1)))/2;
    Ymid = (max(points(:,2)) + min(points(:,2)))/2;
    Xspan = (max(points(:,1)) - min(points(:,1)));
    Yspan = (max(points(:,2)) - min(points(:,2)));
    
    % Default values
    binCenters = false;
    upSample = 1;
    overspan = 1;
    % Optimal resolution for a bivariate normal
    rho = corr(points(:,1),points(:,2));
    resolution = 3.504*std(points,[],1)*((1 - rho^2)^(3/8))*(nPoints^(-1/4));
    % Provisional Ngrid
    Ngrid = [ceil((1 + overspan)*Xspan/resolution(1)),ceil((1 + overspan)*Yspan/resolution(2))];
    
    if nargin >= 3
        if mod(nargin-1,2)
            error('Unpaired Name/Value arguments.');
        end
        
        % If Name/Value arguments are present, reset to adjust to those
        for argN = 1:2:(nargin-1)
            if strcmp(varargin{argN},'Resolution')
                resolution = varargin{argN+1};
                % Recalc Ngrid
                Ngrid = [ceil((1 + overspan)*Xspan/resolution(1)),ceil((1 + overspan)*Yspan/resolution(2))];
            elseif strcmp(varargin{argN}, 'Overspan')
                overspan = varargin{argN+1};
                % Recalc Ngrid
                Ngrid = [ceil((1 + overspan)*Xspan/resolution(1)),ceil((1 + overspan)*Yspan/resolution(2))];
            elseif strcmp(varargin{argN}, 'Ngrid')
                Ngrid = varargin{argN+1};
                % Recalc resolution
                resolution = [(1 + overspan)*Xspan/Ngrid(1),(1 + overspan)*Yspan/Ngrid(2)];
            elseif strcmp(varargin{argN}, 'BinCenters')
                binCenters = varargin{argN+1};
            elseif strcmp(varargin{argN}, 'Upsample')
                upSample = varargin{argN+1};
                if upSample > 1
                    Ngrid = round(Ngrid.*upSample);
                    % Recalc resolution
                    resolution = [(1 + overspan)*Xspan/Ngrid(1),(1 + overspan)*Yspan/Ngrid(2)];
                end
            end   
        end
    end
    
    % Calculate lists from grid and resolution
    Xlist = [1:(Ngrid(1)+1)]*resolution(1) - mean([1:(Ngrid(1)+1)]*resolution(1)) + Xmid;
    Ylist = [1:(Ngrid(2)+1)]*resolution(2) - mean([1:(Ngrid(2)+1)]*resolution(2)) + Ymid;
    
    % If directed to get centers instead of edges, convert to centers
    if binCenters
        Xlist = edgesToCenters(Xlist);
        Ylist = edgesToCenters(Ylist);
    end
end