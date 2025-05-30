classdef WaitingTime < StateVar

    properties
        JoinTime
    end

    methods
        function obj = WaitingTime()
            obj@StateVar(); % Chiama il costruttore della superclasse
            obj.JoinTime = [];
        end

        function Update(obj, clock)
            obj.Values(end) = clock - obj.JoinTime; 
            obj.CurrentState = obj.CurrentState + obj.Values(end);
        end

        function CleanState(obj)
            obj.Times = [];
            obj.Values = [];
            obj.CurrentState = 0;
        end

        function AddJoinTime(obj, JoinTime)
            obj.JoinTime(end+1) = JoinTime;
        end

        function finalState = EvaluateFinalState(obj)
            if isempty(obj.Times)
                finalState = 0;
            else
                finalState = obj.CurrentState / obj.Times(end);
            end
        end
    end
end
