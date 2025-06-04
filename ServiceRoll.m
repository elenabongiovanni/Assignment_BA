classdef ServiceRoll < Event
    
    methods 
        function Manage(obj, Sim)
            roll = Roll(Sim.Clock); % Sim.IdRoll
            % Sim.IdRoll = Sim.IdRoll + 1;
            % fprintf("nuovo roll id %d\n", roll.Id);
            
            if ~ isempty(Sim.ResidualDemand)  % customer in queue, serve demand
                Sim.ResidualDemand(1) = Sim.ResidualDemand(1)-1;
                if Sim.ResidualDemand(1) == 0 % service completed
                    %Sim.WaitingTime.Update(obj.Next, Sim.JoinTime(1))
                    Sim.MyQueue.AddServed(); % ho servito un altro cliente 
                    Sim.Count = Sim.Count + 1;
                
                    % dequeue
                    Sim.JoinTime(1) = [];
                    Sim.ResidualDemand(1) = [];
                end
            else % no customer, increase buffer count
                Sim.Buffer.UpdateQueue(roll);
            end
            if Sim.Buffer.Blocked
                obj.Next = inf;
            else
                obj.GenerateNext(Sim.Clock);
            end

        end

    end

end