classdef Driver < Client

    properties
        FuelInlet
        FuelPump
        EndTime
    end

    methods 
        function obj = Driver(Id, EnterTime)
            obj@Client(Id, EnterTime);
            obj.FuelInlet = randi([1,2]);
            obj.FuelPump = NaN;
            obj.EndTime = inf;
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