classdef Pumps < handle

    properties
        NumLines
        NumPumps % per fila
        PumpsList % pompe
        NumClients
        Block % 2 variabili booleane -> 1 per due pompe, 2 per le altre due
    end

    methods
        function obj = Pumps(NumLines, NumPumps)
            obj.NumLines = NumLines;
            obj.NumPumps = NumPumps;
            obj.PumpsList = zeros(NumLines, NumPumps);
            obj.NumClients = 0;
            obj.Block = false(1, NumLines);
        end

        function Update(obj, Sim)
            client = Sim.ClientQueue.ClientsList{obj.NumClients + 1};

            if obj.PumpsList(client.FuelInlet, 1) == 0

                obj.Add();
                Sim.WaitingTimeQueue.Update(Sim.Clock, client);
             
                if obj.PumpsList(client.FuelInlet, 2) == 1
                    obj.PumpsList(client.FuelInlet, 1) = 1;
                    client.FuelPump = 1;

                    Sim.FuelService.GenerateNext(Sim.Clock);
                    client.EndRefill(Sim.FuelService.Next)
                else
                    obj.PumpsList(client.FuelInlet, 2) = 1;
                    client.FuelPump = 2;

                    Sim.FuelService.GenerateNext(Sim.Clock);
                    client.EndRefill(Sim.FuelService.Next)
                end
            end
            
            Sim.AvgLengthQueue.Update(Sim.ClientQueue.NumInQueue - obj.NumClients, Sim.Clock);
        end

        function Add(obj)
            obj.NumClients = obj.NumClients + 1;
        end

        function Remove(obj, fuel, side)
            obj.PumpsList(fuel, side) = 0;
            obj.NumClients = obj.NumClients - 1;
        end

        function Blocked(obj, fuel)
            obj.Block(fuel) = true;
        end

        function Unblocked(obj, fuel)
            obj.Block(fuel) = false;
        end
    end
    
end