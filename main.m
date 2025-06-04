clc
clear
close all

rng(1);

% Simulation = SimulationRollQueue(100,10,5);
Simulation = SimulationPetrolStation(1000, 10, 50, 50, 15, 2, 2);

Simulation.Simulazione()