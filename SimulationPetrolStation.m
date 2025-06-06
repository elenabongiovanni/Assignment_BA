classdef SimulationPetrolStation < handle

    properties
        IdClient 
        ClientQueue % coda clienti benzinaio
        ServiceQueue % coda cassa
        Pumps
        Clock 
        % BlockClients
        ToServe % clienti da servire 
        Arrival % arrivi clienti
        FuelService % servizio pompe benzina
        CashService % servizio cassa
        CountBlocked 
        WaitingTimePumps
        WaitingTimeCash
        WaitingTimeExit
        WaitingTimeBlocked
        AvgLengthPumps
        AvgLengthCash
        AvgLengthExit
    end

    methods 
        function obj = SimulationPetrolStation(ToServe, Rate1, Rate2, Rate3, MaxPlaces, NumLines, NumPumps)
            obj.IdClient = 0;
            obj.ClientQueue = Queue(MaxPlaces);
            obj.ServiceQueue = Queue();
            obj.Clock = 0;
            % obj.BlockClients = false(1, 2);
            obj.ToServe = ToServe;
            obj.Arrival = ClientArrivalStation(Rate1, @(x) poissrnd(x));
            obj.FuelService = FuelServiceStation(Rate2, @(x,y) unifrnd(x,y),inf);
            obj.CashService = CashServiceStation(Rate3, @(x,y) unifrnd(x,y),inf);
            obj.CountBlocked = 0;
            obj.WaitingTimePumps = WaitingTime();
            obj.WaitingTimeCash = WaitingTime();
            obj.WaitingTimeExit = WaitingTime();
            obj.WaitingTimeBlocked = WaitingTime();
            obj.Pumps = Pumps(NumLines, NumPumps);
            obj.AvgLengthPumps = AvgLength();
            obj.AvgLengthCash = AvgLength();
            obj.AvgLengthExit = AvgLength();
        end


        function Simulazione(obj)
            while obj.ClientQueue.Served <= obj.ToServe
                obj.Clock = min([obj.Arrival.TimesList(1),min(obj.FuelService.TimesList),obj.CashService.TimesList(1)]);

                disp("arrivo: ")

                for i = 1:length(obj.Arrival.TimesList)
                    disp(obj.Arrival.TimesList(i));
                end
                
                disp("servizio pompa: ")

                for i = 1:length(obj.FuelService.TimesList)
                    disp(obj.FuelService.TimesList(i));
                end

                disp("servizio cassa: ")

                for i = 1:length(obj.CashService.TimesList)
                    disp(obj.CashService.TimesList(i));
                end

                fprintf("clock: %d\n",obj.Clock)

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

            fprintf("Tempo medio attesa coda: %d\n",obj.WaitingTimePumps.EvaluateFinalState())
            fprintf("Tempo medio attesa cassa: %d\n",obj.WaitingTimeCash.EvaluateFinalState())
            fprintf("Tempo medio attesa totale: %d\n",obj.WaitingTimeExit.EvaluateFinalState())
            fprintf("Tempo medio blocco uscita: %d\n",obj.WaitingTimeBlocked.EvaluateFinalState())
            
            fprintf("\nLunghezza media coda: %d\n",obj.AvgLengthPumps.EvaluateFinalState())
            fprintf("Lunghezza media coda cassa: %d\n",obj.AvgLengthCash.EvaluateFinalState())
            fprintf("Lunghezza media persone nel sistema: %d\n",obj.AvgLengthExit.EvaluateFinalState())
            
            fprintf("\nNumero clienti persi: %d\n",obj.ClientQueue.Lost)
            fprintf("Numero clienti bloccati: %d\n", obj.CountBlocked) 
        end

        function UpdateIdClient(obj)
            obj.IdClient = obj.IdClient + 1;
        end

    end
end