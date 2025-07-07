classdef Simulation < handle 

    properties 
        ClientQueue
        Clock
        ToServe
        WaitingTimeQueue
        AvgLengthQueue
    end

    methods
        function obj = Simulation(ToServe, MaxPlaces)

            if nargin > 1
                obj.ClientQueue = Queue(MaxPlaces);
            else
                obj.ClientQueue = Queue();
            end

            obj.Clock = 0;
            obj.ToServe = ToServe;
            obj.WaitingTimeQueue = WaitingTime();
            obj.AvgLengthQueue = AvgLength();
        end
    end

    methods (Abstract)

        StartSimulation()

        WriteResults()

    end

end