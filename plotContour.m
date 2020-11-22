%
% Plots contours from contour matrix using polyshapes. This replaces the draw
% functionality of contourf, so that patch properties can be set more flexibly.
%
% varargin{:} can set any patch property.
%
%%
function h = plotContour(M, varargin)

    M = repairContour(M);

    stIX = 1;
    h = [];
    % Protect against empty M's
    if size(M,2) > 1
        enIX = stIX + M(2, stIX);
        while (stIX < size(M,2))
            enIX = stIX + M(2,stIX);
            M(:,stIX) = NaN;
            stIX = enIX + 1;
        end

        warning('off');
        p = polyshape(M(1,:),M(2,:),'Simplify',true);
        warning('on');
        h = plot(p,varargin{:});
    end
end