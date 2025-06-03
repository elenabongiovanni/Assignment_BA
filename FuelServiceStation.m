classdef FuelServiceStation < Event

        methods
            function Manage(obj,Sim)
                idx = cellfun(@(c) c.EndTime == obj.Next, Sim.ClientQueue.ClientsList);
                Client = Sim.ClientQueue.ClientsList{idx};
                
                Sim.ServiceQueue.UpdateQueue(Client);
                if Sim.ServiceQueue.NumInQueue > 1
                    Sim.WaitingTimeCash.AddJoinTime(obj.Next);
                else
                    Sim.CashService.GenerateNext(Sim.Clock); % ho servito un altro cliente 
                end
                if Sim.ClientQueue.NumInQueue == 1
                    obj.Reset();
                end
            end
        end
        
end