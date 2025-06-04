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
                
                if ~ isempty(Sim.WaitingTimePumps.JoinTime)
                    Sim.WaitingTimePumps.Update(Sim.Clock);
                    Sim.AvgLengthPumps.Update(Sim.ClientQueue.NumInQueue - obj.NumClients, Sim.Clock);
                end
             
                if obj.PumpsList(client.FuelInlet, 2) == 1
                    obj.PumpsList(client.FuelInlet, 1) = 1;
                    Sim.FuelService.GenerateNext(Sim.Clock);
                    client.FuelPump = 1;
                    client.EndRefill(Sim.FuelService.Next)
                else
                    obj.PumpsList(client.FuelInlet, 2) = 1;
                    Sim.FuelService.GenerateNext(Sim.Clock);
                    client.FuelPump = 2;
                    client.EndRefill(Sim.FuelService.Next)
                end
            else
                Sim.WaitingTimePumps.AddJoinTime(Sim.Clock);
                Sim.AvgLengthPumps.Update(Sim.ClientQueue.NumInQueue - obj.NumClients, Sim.Clock);
            end
        end

        function Add(obj)
            obj.NumClients = obj.NumClients + 1;
        end

        function Remove(obj)
            obj.NumClients = obj.NumClients - 1;
        end
    end
    
end