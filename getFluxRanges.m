% Author: Serena Lotreck, lotrecks@msu.edu
% this function defines and returns the ranges for each independent flux
% from which new values will be chosen stochastically

function fluxRanges = getFluxRanges(myFreeFluxes,idx_free,allFluxValues)
    %%% returns a struct object where keys are flux names and 
    %%% values are a vector of len 2, indicating the start and end of the
    %%% flux range
    
    fluxRanges = containers.Map;
    for M = 1:numel(idx_free)
        origFluxIndex = idx_free(M);
        origFluxID = myFreeFluxes(M);
        origFluxID = origFluxID{1};
        origFluxVal = allFluxValues(origFluxIndex);
        if origFluxVal > 0
            rangeNum = origFluxVal*3;
            fluxRange = [0 origFluxVal+rangeNum];
        elseif origFluxVal < 0
            rangeNum = abs(origFluxVal)*3;
            fluxRange = [origFluxVal-rangeNum 0];
        end
        fluxRanges(origFluxID) = fluxRange;
    end
end 
