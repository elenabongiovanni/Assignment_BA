classdef ClientArrivalRoll < Event

    methods
        function Manage(obj, Sim)
            demand = unidrnd(Sim.MaxDemand);

            if ~ isempty(Sim.ResidualDemand) % join queue
                Sim.ResidualDemand(end+1) = demand;
                Sim.WaitingTime.AddJoinTime(obj.Next);
                Sim.MyQueue.Update();
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
                    Sim.WaitingTime.AddJoinTime(obj.Next);
                    Sim.MyQueue.Update();
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