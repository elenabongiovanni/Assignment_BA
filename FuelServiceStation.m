classdef FuelServiceStation < Event

        methods
            function Manage(obj,Sim)
                idx = cellfun(@(c) c.EndTime == Sim.Clock && c.Cash == false, Sim.ClientQueue.ClientsList);
                Client = Sim.ClientQueue.ClientsList{idx};
                
                Client.Cash = true;
                Sim.ServiceQueue.Update(Client);

                Sim.AvgLengthCash.Update(Sim.ServiceQueue.NumInQueue, Sim.Clock);

                if Sim.ServiceQueue.NumInQueue > 1
                    Sim.WaitingTimeCash.AddJoinTime(obj.Next);
                else
                    Sim.CashService.GenerateNext(Sim.Clock); 
                end
            end
        end
end