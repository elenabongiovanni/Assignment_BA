classdef EventsList < StateVar
    properties
        Events
    end

    methods
        function obj = EventsList()
            obj@StateVar(); % Chiama il costruttore della superclasse
            obj.Events = [];
        end

        function Update(obj)
            if numel(obj.Times) >= 2 && numel(obj.Values) >= 2
                deltaTime = obj.Times(end) - obj.Times(end-1);
                obj.CurrentState = obj.CurrentState + deltaTime * obj.Values(end-1);
            end
        end

        function CleanState(obj)
            obj.Events = [];
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