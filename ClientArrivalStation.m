classdef ClientArrivalStation < Event

        methods
            function Manage(obj, Sim)
                    client = Driver(Sim.Clock);
                    Sim.ClientQueue.Update(client, Sim.Pumps.NumClients); 
                    obj.GenerateNext(Sim.Clock);
                    
                    Sim.AvgLengthExit.Update(Sim.ClientQueue.NumInQueue, Sim.Clock);
                    Sim.AvgLengthQueue.Update(Sim.ClientQueue.NumInQueue - Sim.Pumps.NumClients, Sim.Clock);
            end
        end
        
end