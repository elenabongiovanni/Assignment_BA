classdef Queue < handle

    properties
       NumInQueue % lunghezza coda ad ogni evento
       Lost % clienti persi 
       Served % clienti serviti
    end

    methods
        % Costruttore
        function obj = Queue()
            obj.NumInQueue = [];
            obj.Lost = 0;
            obj.Served = 0;
        end
        
        % Aggiungo cliente alla coda 
        function Update = updateQueue(obj)
                Update = obj.NumInQueue.update();
            
        end

        function AddServed(obj)
                obj.Served = obj.Served +1;
        end





    end

end