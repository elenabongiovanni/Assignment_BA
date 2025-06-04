classdef Client < handle

    properties
        % Id
        EnterTime
        % ExitTime = inf
    end

    methods
        function obj = Client(EnterTime) % id
            % obj.Id = Id;
            obj.EnterTime = EnterTime;
        end
    end

    methods (Abstract)
        CleanState()
    end
end