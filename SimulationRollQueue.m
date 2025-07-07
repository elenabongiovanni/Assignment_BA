classdef SimulationRollQueue < Simulation 

    properties 
        Buffer
        Arrival
        Roll
        ResidualDemand
        MaxDemand = 3
    end

methods
    function obj = SimulationRollQueue(ToServe, Rate1, Rate2)
        obj@Simulation(ToServe);
        obj.Buffer = Queue(6);
        obj.Arrival = ClientArrivalRoll(Rate1, @(x)  exprnd(x));
        obj.Roll = ServiceRoll(Rate2, @(x) exprnd(x));
        obj.ResidualDemand = [];
    end
   
    function StartSimulation(obj)
        while obj.ClientQueue.Served < obj.ToServe
            
            if obj.Roll.Next <= obj.Arrival.Next
                obj.Clock = obj.Roll.Next;
                obj.Roll.Manage(obj);
            else
                obj.Clock = obj.Arrival.Next;
                obj.Arrival.Manage(obj);
            end
        end

        obj.WriteResults('results_RollQueue.txt');
    end

    function WriteResults(obj, filename)
        fid = fopen(filename, 'w');
        
            fprintf(fid, "==================== RISULTATI SIMULAZIONE ====================\n\n");
            fprintf(fid, ">>> TEMPI DI ATTESA:\n");
            fprintf(fid, " - Attesa media in coda                   : %.2f\n", obj.WaitingTimeQueue.EvaluateFinalState());
        
            fprintf(fid, "\n>>> LUNGHEZZE MEDIE DELLE CODE:\n");
            fprintf(fid, " - Numero medio di persone in coda        : %.2f\n", obj.AvgLengthQueue.EvaluateFinalState());
        
            fprintf(fid, "\n>>> STATISTICHE CLIENTI:\n");
            fprintf(fid, " - Clienti totali da servire              : %d\n", obj.ToServe);
        
            fprintf(fid, "\n===============================================================\n");
        
            fclose(fid);
    end

end

end