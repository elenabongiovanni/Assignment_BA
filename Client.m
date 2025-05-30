classdef Client < handle

    properties
        Id
        EnterTime
        ExitTime = inf
    end

    methods
        function obj = Client(Id, EnterTime)
            obj.Id = Id;
            obj.EnterTime = EnterTime;
        end
    end

    methods (Abstract)
        Update()

        CleanState()
    end
end