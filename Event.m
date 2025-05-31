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
        function GenerateNext(obj)
            if obj.Next == inf
                obj.RemoveTime();
                obj.Next = obj.TimesList(end-1) + obj.Distribution(obj.Rate);
            else
                obj.Next = obj.Next + obj.Distribution(obj.Rate);
            end

            obj.AddTime(obj.Next);
        end

        function Reset(obj)
            obj.Next = inf;
            obj.AddTime(obj.Next);
        end

        function AddTime(obj, Time)
            obj.TimesList(end+1) = Time;
            sort(obj.TimesList);
        end

        function RemoveTime(obj)
            obj.TimesList(1) = [];
        end

    end

    methods (Abstract)

        %funzione astratta Manage
        Manage()
     
    end

end