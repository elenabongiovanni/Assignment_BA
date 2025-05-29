classdef Driver < Client

    properties
        FuelInlet
        FuelPump
    end

    methods 
        function obj = Driver(FuelInlet)
            obj@Client();
            obj.FuelInlet = FuelInlet;
            obj.Pump = NaN;
        end
    end
end