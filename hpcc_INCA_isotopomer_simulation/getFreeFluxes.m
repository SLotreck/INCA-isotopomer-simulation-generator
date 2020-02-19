% Author: Serena Lotreck, lotrecks@msu.edu
% This script is for extracting the independent fluxes in a given network
% Will eventually modify this such that it can be run on the command line
% and with the model file name passed as an argument

% cd to inca directory 
cd ~/Shachar-Hill_Lab/INCAv1.8

% load model 
basemodel = load('~/Shachar-Hill_Lab/INCA_isotopomer_simulation_x3/MSUmodel_v1.mat');
m = basemodel.m;

% get S object 
% S is the stoich object, which contains: 
% S.N is the stoichiometric matrix
% S.K is the kernel (nullspace) matrix
% S.u is the vector of free flux values that defines your initial guess
% S.vf is a logical vector where true entries correspond to free fluxes
% S.v0 is a vector of fixed flux values 
[v, S] = mod2stoich(m); 

% get free flux vector S.vf
freeFluxes = S.vf;

% S.vf is unlabeled. To identify which fluxes are which, we need the 
% vector of flux id's, which corresponds to the entries in all the elements
% of the S object.
fluxIDs = m.rates.flx.id; 

% remove inactivated reactions from the fluxIDs vector
% unclear how to do this generalizably, at the moment just opening the
% model in the gui and using reaction editor to see which ones are
% activated, and then manually exclude them from the ID vector

% define inactive flux 
influxID1 = 'Suc_out-HLacc';
inactive1 = {strcat(influxID1, '.f')};

% find index of this flux in ID vector 
index = [];
for N = 1:numel(fluxIDs)
    if strcmp(fluxIDs(N),inactive1)
        index = [index N];
    end 
end 

% get rid of inactive flux from ID vector
fluxIDs(index) = [];

% get indices for the true (free) fluxes 
indices = [];
for N = 1:numel(freeFluxes)
    if freeFluxes(N)
        indices = [indices N];
    end 
end

% use these indices to get free fluxes in a new vector
myFreeFluxes = [];
for N = 1:numel(fluxIDs)
    if ismember(N,indices)
        myFreeFluxes = [myFreeFluxes fluxIDs(N)];
    end
end


