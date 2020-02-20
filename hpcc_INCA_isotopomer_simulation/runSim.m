% Author: Serena Lotreck, lotrecks@msu.edu
% this function runs 1 simulation

function runSim(myFreeFluxes,allFluxValues,idx_chng,m,fluxRanges,iteration_num)

    % Select the Reaction ID names to be changed to new flux values
    rxn_chng = myFreeFluxes;
    % Cell numbers you want to change the flux values of
    [~,idx_chng] = ismember(rxn_chng,m.rates.flx.id);
    % It's very important to fix the flux to be changed before changing it
    % otherwise it will be rebalanced after flux feasibility adjustment
    m.rates.flx.fix(idx_chng) = 1;
    
    % Now change the fluxes of interest to a new value
    disp('assigning new flux values')
    for I = 1:numel(idx_chng)
        % get index  of flux
        fluxIndex = idx_chng(I)
        
        % get flux ID and confirm that it's the right one
        fluxID1 = m.rates.flx.id(fluxIndex)
        fluxID2 = myFreeFluxes(I)
        if fluxID1 == fluxID2
            disp('flux IDs are equivalent')
        else
            disp('flux IDs are not equivalent, check code!')
        end 
        fluxID = {fluxID1}
        
        % get range for this flux
        fluxRange = fluxRanges(fluxID)
        
        % randomly assign new flux within range 
        newFlux = (fluxRange(2) - fluxRange(1)).*rand + fluxRange(1);

        % assign new flux 
        m.rates.flx.val(idx_chng(M)) = newFlux;
    end
    
    % Let INCA reconcile the flux values to ensure network feasibility.
    % Overwrite the flux values in the model with adjusted new flux values.
    % Need to select row# for m.rates.flx.val, otherwise a matrix will be assigned
    disp('reconciling flux values')
    allFluxValues(1:length(allFluxValues)) = mod2stoich(m);

    % Simulating new isotope labeling data based on the model with flux values
    % changed and adjusted.
    disp('simulating new labeling data')
    s  = simulate(m);
    
    % Copy new simulated measurements into model and assign it to new model
    disp('assigning new model')
    simmod_new = sim2mod(m,s);
    
    % Extract simulated measurements from the new model,
    % simdata_new contains the simulated isotope labeling data based on new
    % flux values
    [~,simdata_new] = mod2mat(simmod_new);
    
    % Export simulated labeling data to CSV files
    % Make sure simExporter.m is in the working directory
    % The simExporter(simdata, simID) function is to export simdata as csv
    % 1st argument is the simulated data (saved in simdata or simdata_new)
    % 2nd argurment is a string used as an idenfier and will appear in the
    % filenames of each csv output files
    % Each metabolite is saved separately since they vary in matrix size
    metabolites = ['/mnt/scratch/lotrecks/INCA_sims/' iteration_num '_simdata']
    disp(metabolites)
    simExporter(simdata_new, metabolites)
    
    % Export flux data to CSV files
    % Make sure fluxExporter.m is in the working directory
    % The fluxExporter(model, filename) function is to export flux properties as csv
    % 1st argument is an .mod object from the INCA model, from which you want
    % to export the flux properties
    % 2nd argurment is a string used as an idenfier and will appear in the
    % filenames of each csv output files
    fluxes = ['/mnt/scratch/lotrecks/INCA_sims/' iteration_num '_flux_after_manipulation' ]
    disp(fluxes)
    fluxExporter(m, fluxes)
    
end
    
    
   

    