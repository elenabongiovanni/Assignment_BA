classdef CashServiceStation < Event

    methods
        function Manage(obj, Sim)
            client = Sim.ServiceQueue.AddServed();

            if Sim.ServiceQueue.NumInQueue > 0
                obj.GenerateNext(Sim.Clock)
                Sim.WaitingTimeCash.Update(Sim.Clock);
            else
                obj.Next = inf;
            end

            if client.FuelPump == 2
                Sim.ClientQueue.AddServed(client.Id);
                Sim.Pumps.PumpsList(client.FuelInlet, 2) = 0;
                Sim.Pumps.Remove();
                if Sim.BlockClients(client.FuelInlet)
                    Sim.WaitingTimeExit.Update(Sim.Clock);
                    Sim.Pumps.Block(client.FuelInlet) = false;
                    Sim.ClientQueue.AddServed(Sim.BlockClients(client.FuelInlet));
                    Sim.Pumps.PumpsList(client.FuelInlet, 1) = 0;
                    Sim.Pumps.Remove();
                end
            else
                if Sim.PumpsList(client.FuelInlet, 2) == 0
                    Sim.ClientQueue.AddServed(client.Id);
                    Sim.Pumps.PumpsList(client.FuelInlet, 1) = 0;
                    Sim.Pumps.Remove();
                else
                    Sim.BlockClients(client.FuelInlet) = client.Id;
                    Sim.Pumps.Block(client.FuelInlet) = true;
                    Sim.WaitingTimeExit.AddJoinTime(Sim.Clock);
                end
            end
        end
    end
end