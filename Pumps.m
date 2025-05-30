classdef Pumps < handle

    properties
        NumLines
        NumPumps % per fila
        PumpsList % pompe
        NumClients
        Block % 2 variabili booleane -> 1 per due pompe, 2 per le altre due
        WaitingTime
    end

    methods
        function obj = Pumps(NumLines, NumPumps)
            obj.NumLines = NumLines;
            obj.NumPumps = NumPumps;
            obj.PumpsList = zeros(NumLines, NumPumps);
            obj.Block = false(1, numLines);
        end

        function Update(obj, Sim)

            client = Sim.ClientQueue(obj.NumClients + 1);

            if obj.PumpsList(client.FuelInlet, 1) == 0
                obj.Add();
                
                if ~ isempty(obj.WaitingTime.JoinTime)
                    obj.WaitingTime.Update(Sim.Clock);
                end
             
                if obj.PumpsList(client.FuelInlet, 2) == 1
                    obj.PumpsList(client.FuelInlet, 1) = 1;
                    Sim.FuelService.GenerateNext();
                else
                    obj.PumpsList(client.FuelInlet, 2) = 1;
                    Sim.FuelService.GenerateNext();
                end
            else
                obj.WaitingTime.AddJoinTime(end+1) = Sim.Clock;
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