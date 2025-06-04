classdef Queue < handle

    properties
       ClientsList
       NumInQueue % lunghezza coda ad ogni evento
       Lost % clienti persi 
       Served % clienti serviti
       Blocked
       NumMax = Inf;
    end

    methods
        % Costruttore
        function obj = Queue(nummax)
            obj.ClientsList = {};
            obj.NumInQueue = 0;
            obj.Lost = 0;
            obj.Served = 0;
            obj.Blocked = false;
            if nargin > 0
                obj.NumMax = nummax;
            end
        end
        
        % Aggiungo cliente alla coda 

        function UpdateQueue(obj, Client)

            if ~ obj.Blocked
                obj.ClientsList{end+1} = Client;
                obj.NumInQueue = obj.NumInQueue + 1;
            else
                obj.Lost = obj.Lost + 1;
            end
                
            if obj.NumInQueue == obj.NumMax
                obj.Blocked = true;

            end
            
        end

        function served = AddServed(obj, idx) % id
            if obj.NumInQueue > 0
                if nargin > 1
                    % idx = find(cellfun(@(c) c.Id == id, obj.ClientsList));
                    served = obj.ClientsList{idx};
                    obj.ClientsList(idx) = [];
                else                    
                    served = obj.ClientsList{1};
                    obj.ClientsList(1) = [];                      
                end
                obj.NumInQueue = obj.NumInQueue - 1;
            end
                        
            obj.Served = obj.Served + 1;

            disp(obj.Served)

            if obj.Blocked
                obj.Blocked = false;
            end
        end

    end

end