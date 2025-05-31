classdef ClientArrivalRoll < Event

    methods
        function Manage(obj, Sim)
            client = RollClient(Sim.IdClient, Sim.Clock);
            demand = unidrnd(Sim.MaxDemand);
            if ~ isempty(Sim.ResidualDemand) % join queue
                Sim.ResidualDemand(end+1) = demand;
                Sim.JoinTime(end+1) = obj.Next;
                Sim.MyQueue.UpdateQueue(client);
            else
                if Sim.Buffer.NumInQueue >= demand
                    Sim.Buffer.NumInQueue = Sim.Buffer.NumInQueue - demand;
                    obj.MyQueue.AddServed(client.Id);
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
                    Sim.Roll.GenerateNext();
                end

            end

        obj.GenerateNext();

        end

    end

end