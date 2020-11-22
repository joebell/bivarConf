function p = testDistributions(distN, nPoints)

    switch distN
        case 1
            t = pi*rand(nPoints,1);
            p = [sin(t),cos(t)] + 0.1*randn(nPoints,2);
        case 2
            t = 2*pi*rand(nPoints,1);
            p = [sin(t),cos(t)] + 0.2*randn(nPoints,2);
        case 3
            p = [.1, .5].*randn(nPoints,2);
        case 4
            p = [(randi(2,nPoints,1) - 1.5),zeros(nPoints,1)] + 0.15*randn(nPoints,2);
        case 5
            t = pi*rand(nPoints,1);
            p = [t - pi/2,sin(3*t)] + 0.1*randn(nPoints,2);
        case 6
            p = [(randi(2,nPoints,1) - 1.5),(randi(2,nPoints,1) - 1.5)] + 0.15*randn(nPoints,2);
        case 7
            dSelect = (rand(nPoints,1) > 0.5);
            p1 = [1, 1].*randn(nPoints,2);
            p2 = randn(nPoints,2).*[.1,.5] + [.5,0];
            p = (1-dSelect).*p1 + dSelect.*p2;
        case 8
            p = rand(nPoints,2) - [0.5, 0.5];
    end
end