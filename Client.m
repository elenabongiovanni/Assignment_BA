classdef Client < handle

    properties
        EnterTime
        ExitTime = inf
    end

    methods
        function obj = Client(EnterTime)
            obj.EnterTime = EnterTime;
        end
    end

    methods (Abstract)
        Update()

        CleanState()
    end
end