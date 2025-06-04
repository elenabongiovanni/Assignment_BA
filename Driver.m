classdef Driver < Client

    properties
        FuelInlet
        FuelPump
        EndTime
        Cash
    end

    methods 
        function obj = Driver(EnterTime) % id
            obj@Client(EnterTime); % id
            obj.FuelInlet = randi([1,2]);
            obj.FuelPump = NaN;
            obj.EndTime = inf;
            obj.Cash = false;
        end

        function CleanState(obj)
            obj.Id = NaN;
            obj.EnterTime = NaN;
            obj.FuelInlet = NaN;
            obj.FuelPump = NaN;
        end

        function EndRefill(obj, EndTime)
            obj.EndTime = EndTime;
        end
    end
end