classdef WaitingTime < StateVar
    methods
        function obj = WaitingTime()
            obj@StateVar(); % Chiama il costruttore della superclasse
        end

        function Update(obj)
            if ~isempty(obj.Values)
                obj.CurrentState = obj.CurrentState + obj.Values(end);
            end
        end

        function CleanState(obj)
            obj.Times = [];
            obj.Values = [];
            obj.CurrentState = 0;
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
