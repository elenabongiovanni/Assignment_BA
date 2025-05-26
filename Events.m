classdef Events < handle

    properties
        rate
        Next
        distribution
    end

    methods
        % Costruttore 
        function obj = Events(Rate,Distribution)
            obj.rate = Rate;
            obj.Next = Distribution(Rate);
            obj.distribution = Distribution;
        end
        
        % Genero nuovo evento 
        function GenerateNext(obj)
            obj.Next = obj.Next + obj.distribution(obj.rate);

        end

    end

end