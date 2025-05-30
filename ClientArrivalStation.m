classdef ClientArrivalStation < Event

        methods
            function Manage(obj,Sim)
                    Sim.Clock = obj.Next;
                    client = Driver(Sim.IdClient, Sim.Clock);
                    Sim.UpdateIdClient();
                    Sim.ClientQueue.UpdateQueue(client); 
            end
        end
        
end