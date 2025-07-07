classdef Client < handle

    properties
        EnterTime
        EnterBlock
    end

    methods
        function obj = Client(EnterTime) 
            obj.EnterBlock = 0;
            obj.EnterTime = EnterTime;
        end

        function Blocked(obj,clock)
            obj.EnterBlock = clock;
        end
    end

    methods (Abstract)
        CleanState()
    end
end