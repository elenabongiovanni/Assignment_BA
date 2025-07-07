classdef SimulationPetrolStation < Simulation

    properties
        ServiceQueue % coda cassa
        Pumps
        Arrival % arrivi clienti
        FuelService % servizio pompe benzina
        CashService % servizio cassa
        CountBlocked 
        WaitingTimeCash
        WaitingTimeExit
        WaitingTimeBlocked
        AvgLengthCash
        AvgLengthExit
    end

    methods 
        function obj = SimulationPetrolStation(ToServe, Rate1, Rate2, Rate3, MaxPlaces, NumLines, NumPumps)
            obj@Simulation(ToServe, MaxPlaces);
            obj.ServiceQueue = Queue();
            obj.Arrival = ClientArrivalStation(Rate1, @(x) poissrnd(x));
            obj.FuelService = FuelServiceStation(Rate2, @(x,y) unifrnd(x,y),inf);
            obj.CashService = CashServiceStation(Rate3, @(x,y) unifrnd(x,y),inf);
            obj.Pumps = Pumps(NumLines, NumPumps);
            obj.CountBlocked = 0;
            obj.WaitingTimeCash = WaitingTime();
            obj.WaitingTimeExit = WaitingTime();
            obj.WaitingTimeBlocked = WaitingTime();
            obj.AvgLengthCash = AvgLength();
            obj.AvgLengthExit = AvgLength();
        end


        function StartSimulation(obj)

            while obj.ClientQueue.Served <= obj.ToServe

                obj.Clock = min([obj.Arrival.TimesList(1),min(obj.FuelService.TimesList),obj.CashService.TimesList(1)]);
                
                if obj.Clock == obj.CashService.TimesList(1)
                    obj.CashService.Manage(obj);
                    obj.CashService.RemoveTime()
                end

                if obj.Clock == min(obj.FuelService.TimesList)
                    obj.FuelService.Manage(obj);
                    obj.FuelService.RemoveTime();
                end

                if obj.Clock == obj.Arrival.TimesList(1)
                    obj.Arrival.Manage(obj);
                    obj.Arrival.RemoveTime();
                end

                if obj.ClientQueue.NumInQueue > obj.Pumps.NumClients
                    obj.Pumps.Update(obj);
                end
                
            end

            obj.WriteResults('results_PetrolStation.txt');
        end

        function WriteResults(obj, filename)
            fid = fopen(filename, 'w');
        
            fprintf(fid, "==================== RISULTATI SIMULAZIONE ====================\n\n");
            fprintf(fid, ">>> TEMPI DI ATTESA:\n");
            fprintf(fid, " - Attesa media alla pompa      : %.2f\n", obj.WaitingTimeQueue.EvaluateFinalState());
            fprintf(fid, " - Attesa media alla cassa      : %.2f\n", obj.WaitingTimeCash.EvaluateFinalState());
            fprintf(fid, " - Attesa media totale          : %.2f\n", obj.WaitingTimeExit.EvaluateFinalState());
            fprintf(fid, " - Blocco medio all'uscita      : %.2f\n", obj.WaitingTimeBlocked.EvaluateFinalState());
        
            fprintf(fid, "\n>>> LUNGHEZZE MEDIE DELLE CODE:\n");
            fprintf(fid, " - Coda media alle pompe         : %.2f\n", obj.AvgLengthQueue.EvaluateFinalState());
            fprintf(fid, " - Coda media alla cassa         : %.2f\n", obj.AvgLengthCash.EvaluateFinalState());
            fprintf(fid, " - Persone medie nel sistema     : %.2f\n", obj.AvgLengthExit.EvaluateFinalState());
        
            fprintf(fid, "\n>>> STATISTICHE CLIENTI:\n");
            fprintf(fid, " - Clienti totali da servire     : %d\n", obj.ToServe);
            fprintf(fid, " - Clienti persi (posti finiti)  : %d\n", obj.ClientQueue.Lost);
            fprintf(fid, " - Clienti bloccati in uscita    : %d\n", obj.CountBlocked);
        
            fprintf(fid, "\n===============================================================\n");
        
            fclose(fid);
        end


    end
end