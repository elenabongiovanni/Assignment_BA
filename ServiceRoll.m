classdef ServiceRoll < Event
    
    methods 
        function Manage(obj, Sim)
            %roll = Roll(Sim.Clock); 
            
            if ~ isempty(Sim.ResidualDemand)  % customer in queue, serve demand
                Sim.ResidualDemand(1) = Sim.ResidualDemand(1)-1;

                if Sim.ResidualDemand(1) == 0 % service completed
                    Sim.WaitingTimeQueue.Update(obj.Next);
                    Sim.ClientQueue.AddServed(); % ho servito un altro cliente 
                
                    % dequeue
                    Sim.ResidualDemand(1) = [];
                end
            else % no customer, increase buffer count
                Sim.Buffer.Update();
            end
            
            if Sim.Buffer.Blocked
                obj.Next = inf;
            else
                obj.GenerateNext(Sim.Clock);
            end

            Sim.AvgLengthQueue.Update(Sim.ClientQueue.NumInQueue, Sim.Clock);
        end

    end

end