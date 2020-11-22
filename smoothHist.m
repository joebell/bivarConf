function N = smoothHist(N, smoothBins)

    if smoothBins > 0
        % Make a gaussian kernel out to 5*sigma
        sig = 5;
        kernelSize = ceil([sig*smoothBins,sig*smoothBins]);
        z = fspecial('gaussian', kernelSize, smoothBins);

        % Convolve histogram counts with the gaussian
        N = conv2(N,z,'same');
    end
end