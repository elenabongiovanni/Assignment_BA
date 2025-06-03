clc
clear
close all

rng(1);

% Simulation = SimulationRollQueue(100,10,5);
Simulation = SimulationPetrolStation(1000, 10, 7, 4, 15, 2, 2);

Simulation.Simulazione()