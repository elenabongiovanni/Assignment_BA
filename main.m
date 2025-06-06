clc
clear
close all

rng(1);

% Simulation = SimulationRollQueue(100,10,5);
Simulation = SimulationPetrolStation(1000, 3 ,[2,5], [1,2], 8, 2, 2);

Simulation.Simulazione()