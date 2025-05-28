classdef ServiceRoll < Event
    
    methods 
        function Manage(obj, sim)
            if ~ isempty(sim.ResidualDemand)  % customer in queue, serve demand
                sim.ResidualDemand(1) = sim.ResidualDemand(1)-1;
                if sim.ResidualDemand(1) == 0 % service completed
                    sim.WaitingTime.Update(obj.Next, sim.JoinTime(1))
                    sim.MyQueue.AddServed(); % ho servito un altro cliente 
                    sim.Count = sim.Count + 1;
                
                    % dequeue
                    sim.JoinTime(1) = [];
                    sim.ResidualDemand(1) = [];
                end
            else % no customer, increase buffer count
                sim.Buffer.updateQueue();
            end
            if sim.Buffer.Blocked
                obj.Next = inf;
            else
                obj.GenerateNext();
            end

        end

    end

end