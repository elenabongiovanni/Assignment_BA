classdef ClientArrivalRoll < Event

    methods
        function Manage(obj, Sim)
            client = RollClient(Sim.Clock); % Sim.IdClient
            % Sim.IdClient = Sim.IdClient + 1;
            % fprintf('nuovo cliet id %d\n', client.Id);
            demand = unidrnd(Sim.MaxDemand);
            fprintf('domanda cliente %d\n' ,demand);
            if ~ isempty(Sim.ResidualDemand) % join queue
                Sim.ResidualDemand(end+1) = demand;
                Sim.JoinTime(end+1) = obj.Next;
                Sim.MyQueue.UpdateQueue(client);
            else
                if Sim.Buffer.NumInQueue >= demand
                    Sim.Buffer.NumInQueue = Sim.Buffer.NumInQueue - demand;
                    Sim.MyQueue.AddServed();
                    Sim.Count = Sim.Count + 1;

                else
                   
                    if Sim.Buffer.NumInQueue ~= 0
                        demand = demand - Sim.Buffer.NumInQueue;
                        Sim.Buffer.NumInQueue = 0;
                    end
                    
                    Sim.ResidualDemand(1) = demand;
                    Sim.JoinTime(1) = obj.Next;
                    Sim.MyQueue.UpdateQueue(client);
                end

                if Sim.Buffer.Blocked
                    Sim.Buffer.Blocked = false;
                    Sim.Roll.GenerateNext(Sim.Clock);
                end

            end

        obj.GenerateNext(Sim.Clock);

        end

    end

end