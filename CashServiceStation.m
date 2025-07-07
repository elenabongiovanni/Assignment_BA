classdef CashServiceStation < Event

    methods

        function Manage(obj, Sim)
            client = Sim.ServiceQueue.AddServed();
            idx_served = cellfun(@(c) c == client, Sim.ClientQueue.ClientsList);
            Sim.AvgLengthCash.Update(Sim.ServiceQueue.NumInQueue, Sim.Clock);

            if Sim.ServiceQueue.NumInQueue > 0
                obj.GenerateNext(Sim.Clock)
                Sim.WaitingTimeCash.Update(Sim.Clock);
            end

            if client.FuelPump == 2
                Sim.ClientQueue.AddServed(idx_served);
                Sim.WaitingTimeExit.Update(Sim.Clock, client)
                Sim.Pumps.Remove(client.FuelInlet, 2);

                if Sim.Pumps.Block(client.FuelInlet)
                    idx_blocked = cellfun(@(c) c.FuelInlet == client.FuelInlet && c.FuelPump == 1, Sim.ClientQueue.ClientsList);
                    blockedClient = Sim.ClientQueue.ClientsList{idx_blocked};

                    Sim.WaitingTimeBlocked.Update(Sim.Clock, blockedClient);
                    Sim.WaitingTimeExit.Update(Sim.Clock, blockedClient);

                    Sim.Pumps.Block(client.FuelInlet) = false;                    
                    Sim.ClientQueue.AddServed(idx_blocked);
                    Sim.Pumps.Remove(client.FuelInlet, 1);
                end
            else
                if Sim.Pumps.PumpsList(client.FuelInlet, 2) == 0
                    Sim.ClientQueue.AddServed(idx_served);
                    Sim.Pumps.Remove(client.FuelInlet, 1);

                    Sim.WaitingTimeExit.Update(Sim.Clock, client)
                else
                    client.Blocked(Sim.Clock);
                    Sim.CountBlocked = Sim.CountBlocked + 1;
                    Sim.Pumps.Blocked(client.FuelInlet);
                    Sim.WaitingTimeBlocked.AddJoinTime(Sim.Clock);   
                end
            end

            Sim.AvgLengthExit.Update(Sim.ClientQueue.NumInQueue, Sim.Clock);
        end
    end
end