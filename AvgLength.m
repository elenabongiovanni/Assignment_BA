classdef AvgLength < StateVar
    properties
        Events
    end

    methods
        function obj = AvgLength()
            obj@StateVar(); % Chiama il costruttore della superclasse
            obj.Events = [];
        end

        function Update(obj, value, time)
            obj.Times(end+1) = time;
            
            if numel(obj.Times) >= 2 && numel(obj.Values) >= 2
                deltaTime = obj.Times(end) - obj.Times(end-1);
                obj.CurrentState = obj.CurrentState + deltaTime * obj.Values(end);
            end

            obj.Values(end+1) = value;
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