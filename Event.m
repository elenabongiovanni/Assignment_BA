classdef Event < handle

    properties
        Rate
        Next
        Distribution
        TimesList
    end

    methods
        % Costruttore 
        function obj = Event(Rate,Distribution, Next)
            obj.Rate = Rate;
            if nargin > 2
                obj.Next = Next;
            else
                obj.Next = Distribution(Rate);
            end
            
            obj.Distribution = Distribution;
            obj.TimesList(1) = obj.Next;
        end
        
        % Genero nuovo evento 
        function GenerateNext(obj, clock)
            obj.Next = clock + obj.Distribution(obj.Rate);
            obj.AddTime(obj.Next);

            if obj.TimesList(1) == inf
                obj.RemoveTime();
            end
        end

        % function Reset(obj)
        %     obj.Next = inf;
        %     obj.AddTime(obj.Next);
        % end

        function AddTime(obj, Time)
            obj.TimesList(end+1) = Time;
            sort(obj.TimesList);
        end

        function RemoveTime(obj)
            obj.TimesList(1) = [];

            if isempty(obj.TimesList)
                obj.AddTime(inf);
            end
        end

    end

    methods (Abstract)

        %funzione astratta Manage
        Manage()
     
    end

end