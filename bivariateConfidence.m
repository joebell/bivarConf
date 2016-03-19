%%
%	Bootstrap bivariate confidence regions
%
%	Each row of X and Y is a replicate. (Columns of X and Y are points in a series.)
%	Here datapoints are not paired, and X and Y can have different numbers of 
%	replicates.
%	
function bivariateConfidence(X,Y,nBoots, plotColor)

	% Define confidence region desired
    alpha = 1 - .95;

    nX = size(X,1);
    nY = size(Y,1);

	% Find the mean trend-line of the series data
    meanX = nanmean(X,1);
    meanY = nanmean(Y,1);

	% Make bootstrap resamples
    mXr = zeros(nBoots,size(X,2));
    mYr = zeros(nBoots,size(Y,2));
    for bootN = 1:nBoots
        % Make a resample without replacement
		% Note these resamples are not paired
        Xr = X(randi(nX,nX,1),:);
        Yr = Y(randi(nY,nY,1),:);
        % Find mean trend-line of a resample, store it
        mXr(bootN,:) = nanmean(Xr,1);
        mYr(bootN,:) = nanmean(Yr,1);
    end

	% Use the resampled mean trend-lines. Make a 2D histogram of cumulative
	% density as we approach the data trend-line
    [N, Xbins, Ybins] = lineHist(mXr,mYr, meanX, meanY);


	  % Plot a histogram of cumulative density approaching the mean.
      subplot(1,2,1);
      image(Xbins, Ybins, N'./max(N(:)),'CDataMapping','scaled');
      set(gca,'YDir','normal'); 
     
	  % Find the contour at alpha/2 approaching the mean 
	  subplot(1,2,2);
      [C, h] = contourf(Xbins, Ybins, N'./max(N(:)),[alpha/2 alpha/2]); hold on;
      set(h,'LineStyle','none');
      set(get(h,'Children'),'FaceAlpha',.5,'FaceColor',plotColor,'EdgeColor','none');
      plot(meanX,meanY,'.-','Color',plotColor); 

% Make a cumulative 2D histogram of X and Y resamples as we approach the mean trend-line
function [N, Xbins, Ybins] = lineHist(X,Y,meanX,meanY)

	% Determine how finely to grid for the joint histogram
    overSample = 2;
    axPoints = 64;
    minX = min(X(:)); maxX = max(X(:));
    minY = min(Y(:)); maxY = max(Y(:));
    Xbins = linspace(minX,maxX,axPoints);
   
    % Upsample the trend-line	
    meanXi = linspace(meanX(1),meanX(end),axPoints*overSample);
    meanYi = interp1(meanX,meanY,meanXi);
    
    Ybins = linspace(minY,maxY,axPoints);
    
    N = zeros(axPoints,axPoints);

	% For each of the bootstrapped mean trend-lines...
    for rowN = 1:size(X,1)      
        if (mod(rowN,50) == 0)
            disp(['Bootstrap #',num2str(rowN)]);
        end
        rX = X(rowN,:);
        rY = Y(rowN,:);
        % Interpolate points for the mean line of the bootstrap sample
        xi = linspace(rX(1),rX(end),axPoints*overSample);
        yi = interp1(rX,rY,xi);
        
        Ni = zeros(axPoints,axPoints);
        % For each point, draw the chord to the corresponding point along 
		% the mean trend-line for the data
        for ptN = 1:length(xi)
            xtt = linspace(xi(ptN),meanXi(ptN),axPoints*overSample);
            ytt = linspace(yi(ptN),meanYi(ptN),axPoints*overSample);
            Nii = hist3([xtt(:),ytt(:)],{Xbins,Ybins});
            Ni = Ni + Nii;
        end
        % Add 1 count to each bin the trace passes through        
        Ni = (Ni > 0);               
        N = N + Ni;                           
    end



  
        
        
        
        
