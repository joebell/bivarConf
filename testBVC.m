%% 
%	Example code for bivariate confidence intervals
%
function testBVC()

	% Define the mean points
	Xmean = [1 2 4 5 6 6.5 7 9];
	Ymean = [1 2 6 8 10 9 8 7];

	% Define the # of points and variability
	nX = 32;
	CVx = 3;
	nY = 24;
	CVy = 5;

	% Generate random points
	for p = 1:length(Xmean)
		for n = 1:nX
			X(n, p) = rand()*CVx*Xmean(p) + Xmean(p);
		end
	end
	for p = 1:length(Ymean)
		for n = 1:nY
			Y(n, p) = rand()*CVy*Ymean(p) + Ymean(p);
		end
	end
	
	X

	Y

	bivariateConfidence(X, Y, 200, 'b');


