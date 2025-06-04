classdef ClientArrivalStation < Event

        methods
            function Manage(obj, Sim)
                    client = Driver(Sim.Clock); % Sim.IdClient
                    % Sim.UpdateIdClient();
                    Sim.ClientQueue.UpdateQueue(client); 
                    obj.GenerateNext(Sim.Clock);
                    Sim.AvgLengthExit.Update(Sim.ClientQueue.NumInQueue, Sim.Clock);
            end
        end
        
end