classdef ServiceRoll < Event
    
    methods 
        function Manage(obj, sim)
            if ~ isempty(sim.residualDemand)  % customer in queue, serve demand
                sim.residualDemand(1) = sim.residualDemand(1)-1;
                if sim.residualDemand(1) == 0 % service completed
                    sim.WaitingTime.update(obj.Next, sim.joinTime(1))
                    obj.MyQueue.AddServed(); % ho servito un altro cliente 
                
                    % dequeue
                    sim.joinTime(1) = [];
                    obj.residualDemand(1) = [];
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