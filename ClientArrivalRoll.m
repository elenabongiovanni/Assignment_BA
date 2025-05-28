classdef ClientArrivalRoll < Event

    methods
        function Manage(obj, sim)
            demand = unidrnd(sim.MaxDemand);
            if ~ isempty(sim.ResidualDemand) % join queue
                sim.ResidualDemand(end+1) = demand;
                sim.JoinTime(end+1) = obj.Next;
                sim.MyQueue.updateQueue();
            else
                if sim.Buffer.NumInQueue >= demand
                    sim.Buffer.NumInQueue = sim.Buffer.NumInQueue - demand;
                    obj.MyQueue.AddServed();
                    sim.Count = sim.Count + 1;

                else
                   
                    if sim.Buffer.NumInQueue ~= 0
                        demand = demand - sim.Buffer.NumInQueue;
                        sim.Buffer.NumInQueue = 0;
                    end
                    
                    sim.ResidualDemand(1) = demand;
                    sim.JoinTime(1) = obj.Next;
                    sim.MyQueue.updateQueue();
                end

                if sim.Buffer.Blocked
                    sim.Buffer.Blocked = false;
                    sim.Roll.GenerateNext();
                end

            end

        obj.GenerateNext();

        end

    end

end