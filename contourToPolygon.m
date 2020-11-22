%%
% contourToPolygon.m
%
% Parses a contour matrix into polygon syntax, separated by NaNs.
% If there are multiple polygons in the matrix it alternates the orientation of them.
% (This is necessary for inpolygon() to correctly orient to holes.)
%
%%
function poly = contourToPolygon(M)

    % Repair discontinuities
    M = repairContour(M);

    ix = 1;
    poly = [];
    oddPath = true;
    while ix < size(M,2)
        span = M(2,ix);
        xv = M(1,(ix+1):(ix+span));
        yv = M(2,(ix+1):(ix+span));
        
        series = [xv(:),yv(:)];
        if size(series,1) > 2
            % Orient the curve
            seriesDiff = diff(series([1:end,1],:),1,1);
            seriesDiff(:,3) = 0;
            sd2 = seriesDiff([2:end,1],:);
            cp = cross(seriesDiff,sd2);
            orientation = mean(cp(:,3));

            if ((oddPath && (orientation > 0)) | (~oddPath && (orientation < 0)))
                xv = flip(xv);
                yv = flip(yv);
            end
            poly = cat(1,poly,[xv(:), yv(:)]);
            poly = cat(1,poly,[NaN,NaN]);
        end
        oddPath = ~oddPath;
        ix = ix + span + 1;
    end
end