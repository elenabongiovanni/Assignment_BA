classdef CashServiceStation < Event

    methods
        function Manage(obj, Sim)
            client = Sim.ServiceQueue.AddServed();
            idx_served = cellfun(@(c) c == client, Sim.ClientQueue.ClientsList);
            Sim.AvgLengthCash.Update(Sim.ServiceQueue.NumInQueue, Sim.Clock);

            if Sim.ServiceQueue.NumInQueue > 0
                obj.GenerateNext(Sim.Clock)
                Sim.WaitingTimeCash.Update(Sim.Clock);
            % else
            %     obj.Reset();
            end

            if client.FuelPump == 2
                Sim.ClientQueue.AddServed(idx_served);
                Sim.WaitingTimeExit.Update(Sim.Clock, client)
                Sim.Pumps.PumpsList(client.FuelInlet, 2) = 0;
                Sim.Pumps.Remove();
                if Sim.Pumps.Block(client.FuelInlet)
                    idx_blocked = cellfun(@(c) c.FuelInlet == client.FuelInlet && c.FuelPump == 1, Sim.ClientQueue.ClientsList);
                    Sim.WaitingTimeExit.Update(Sim.Clock);
                    Sim.Pumps.Block(client.FuelInlet) = false;
                    Sim.ClientQueue.AddServed(idx_blocked);
                    Sim.Pumps.PumpsList(client.FuelInlet, 1) = 0;
                    Sim.Pumps.Remove();
                end
            else
                if Sim.Pumps.PumpsList(client.FuelInlet, 2) == 0
                    Sim.ClientQueue.AddServed(idx_served);
                    Sim.Pumps.PumpsList(client.FuelInlet, 1) = 0;
                    Sim.Pumps.Remove();
                else
                    % Sim.BlockClients(client.FuelInlet) = client.Id;
                    Sim.Pumps.Block(client.FuelInlet) = true;
                    Sim.WaitingTimeExit.AddJoinTime(Sim.Clock);
                end
            end

            Sim.AvgLengthExit.Update(Sim.ClientQueue.NumInQueue, Sim.Clock);
        end
    end
end