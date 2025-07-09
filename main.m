clc
clear
close all

rng(1);

SimulationRoll = SimulationRollQueue(100,10,5);
SimulationStation = SimulationPetrolStation(1000, 3 ,[2,5], [1,2], 8, 2, 2);

SimulationRoll.StartSimulation();
SimulationStation.StartSimulation();