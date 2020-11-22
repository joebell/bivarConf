%
% scaleBandwidth (optional)
%
function P = adaptiveBivariateKDE(points, Xlist, Ylist, varargin)

    scaleBandwidth = 1;
    for argN = 1:2:(nargin-3)
        if strcmp(varargin{argN},'ScaleBandwidth')
                scaleBandwidth = varargin{argN+1};
        end
    end

    % Frame points to prevent unbounded Voronoi cells
    frame = [max(points(:,1))+1,max(points(:,2))+1;...
         max(points(:,1))+1,min(points(:,2))-1;
         min(points(:,1))-1,max(points(:,2))+1;
         min(points(:,1))-1,min(points(:,2))-1];
    framedPoints = cat(1,points,frame); 
    % Calculate the Delaunay Triangulation
    dt = delaunayTriangulation(framedPoints);
    [V,R] = voronoiDiagram(dt);
    % Calculate areas of the Voronoi cells that correspond to each data point
    % Don't calculate areas for the framing points, which are unbounded
    A = zeros(size(points,1),1);
    for n = 1:size(points,1)
        x = V(R{n},1);
        y = V(R{n},2);
        A(n) = polyarea(x,y);
    end
    
    % Create a list of probe points, shape into a list
    [X,Y] = meshgrid(Xlist,Ylist);
    probePoints = [X(:),Y(:)];

    % Calculate the gaussian contribution from each data point to each probe point
    sigmaSq = scaleBandwidth*A';
    dSq = (probePoints(:,1) - points(:,1)').^2 + (probePoints(:,2) - points(:,2)').^2;
    G = 1./(sqrt(2*pi*sigmaSq)).*exp(-dSq./(2*sigmaSq));
    % Sum across data points
    Gtot = sum(G,2);
    
    % Reshape and normalize
    P = reshape(Gtot,size(X));
    P = P./sum(P(:));
end