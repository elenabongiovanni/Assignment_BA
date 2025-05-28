classdef Queue < handle

    properties
       NumInQueue % lunghezza coda ad ogni evento
       Lost % clienti persi 
       Served % clienti serviti
       Blocked
       NumMax = Inf;
    end

    methods
        % Costruttore
        function obj = Queue(nummax)
            obj.NumInQueue = [];
            obj.Lost = 0;
            obj.Served = 0;
            obj.Blocked = false;
            if nargin > 0
                obj.NumMax = nummax;
            end
        end
        
        % Aggiungo cliente alla coda 
        function updateQueue(obj)
            if ~ obj.Blocked
                obj.NumInQueue = obj.NumInQueue + 1;
            end

            if obj.NumInQueue == obj.NumMax
                obj.Blocked = true;
            end
            
        end

        function AddServed(obj)
                obj.Served = obj.Served +1;
        end





    end

end