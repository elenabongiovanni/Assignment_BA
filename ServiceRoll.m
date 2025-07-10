classdef ServiceRoll < Event
    
    methods 
        function Manage(obj, Sim)
            
            if ~ isempty(Sim.ResidualDemand)  % ho clienti in coda, servo il primo
                Sim.ResidualDemand(1) = Sim.ResidualDemand(1)-1;

                if Sim.ResidualDemand(1) == 0 % domanda tutta soddifatta
                    Sim.WaitingTimeQueue.Update(obj.Next);
                    Sim.ClientQueue.AddServed(); % ho servito un altro cliente 
                
                    % dequeue
                    Sim.ResidualDemand(1) = [];
                end
            else % non ci sono clienti, aumento il buffer
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