classdef ClientArrivalStation < Event

        methods
            function Manage(obj, Sim)
                    client = Driver(Sim.IdClient, Sim.Clock);
                    Sim.UpdateIdClient();
                    Sim.ClientQueue.UpdateQueue(client); 
                    obj.GenerateNext();
            end
        end
        
end