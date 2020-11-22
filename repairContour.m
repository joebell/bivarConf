%
% Adds curves to the contour matrix M to repair discontinuities at histogram edges.
%
%%
function M = repairContour(M)
    stIX = 1;

    % Protect against empty M's
    if size(M,2) > 1
        discPts = [];
        enIX = stIX + M(2, stIX);
        while (stIX < size(M,2))
            level = M(1,stIX);
            enIX = stIX + M(2,stIX);
            % Detect discontinuities at matrix edges
            if ~isequal(M(:,stIX+1),M(:,enIX))
                discPts = cat(2,discPts,M(:,[stIX+1,enIX]));
            end
            stIX = enIX + 1;
        end
        if size(discPts,2) >= 3
            % Orient the discontinuous points and add them as another curve
            discMean = mean(discPts,2);
            angles = atan2(discPts(2,:) - discMean(2),discPts(1,:) - discMean(1));
            [~,ix] = sort(angles,'ascend');
            M = cat(2,M,[level;length(ix)+1]);
            M = cat(2,M,discPts(:,[ix(1:end),ix(1)]));
        end
    end
end