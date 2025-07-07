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
                if length(Rate) == 2
                    obj.Next = Distribution(Rate(1),Rate(2));
                else
                    obj.Next = Distribution(Rate);
                end
            end
            
            obj.Distribution = Distribution;
            obj.TimesList(1) = obj.Next;
        end
        
        % Genero nuovo evento 
        function GenerateNext(obj, clock)

            if length(obj.Rate) == 2
                obj.Next = clock + obj.Distribution(obj.Rate(1),obj.Rate(2));
            else
                obj.Next = clock + obj.Distribution(obj.Rate);
            end

            obj.AddTime(obj.Next);

            if obj.TimesList(1) == inf
                obj.RemoveTime();
            end

            obj.TimesList = sort(obj.TimesList);
            
        end

        function AddTime(obj, Time)
            obj.TimesList(end+1) = Time;
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