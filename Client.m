classdef Client < handle

    properties
        % Id
        EnterTime
        EnterBlock
        % ExitTime = inf
    end

    methods
        function obj = Client(EnterTime) % id
            % obj.Id = Id;
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