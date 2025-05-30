classdef FuelServiceStation < Event

        methods
            function Manage(obj,Sim) 
                    Sim.Clock = obj.Next;
                    Sim.ServiceQueue.Update();
                    if Sim.ServiceQueue.NumInQueue >0
                        Sim.WaitingTimeCash.AddJoinTime(obj.Next);
                    else
                        Sim.CashService.GenerateNext(); % ho servito un altro cliente 

                    end

            end
        end
        
end