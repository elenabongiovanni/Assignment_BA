classdef WaitingTime < StateVar

    properties
        JoinTime
    end

    methods
        function obj = WaitingTime()
            obj@StateVar(); % Chiama il costruttore della superclasse
            obj.JoinTime = [];
        end

        function Update(obj, clock, client)
            obj.Times(end+1) = clock;
            
            if nargin > 2
                if client.EnterBlock ==0
                    obj.Values(end+1) = clock - client.EnterTime; 
                else
                    obj.Values(end+1) = clock - client.EnterBlock;
                    client.EnterBlock = 0;
                end
                            
            else
                obj.Values(end+1) = clock - obj.JoinTime(1); 
                obj.JoinTime(1) = [];
            end
            
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
