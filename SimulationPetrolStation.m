classdef SimulationPetrolStation < handle

    properties
        IdClient 
        ClientQueue % coda clienti benzinaio
        ServiceQueue % coda cassa
        Pumps
        Clock 
        BlockClients
        ToServe % clienti da servire 
        Arrival % arrivi clienti
        FuelService % servizio pompe benzina
        CashService % servizio cassa
        WaitingTimeCash
        WaitingTimeExit
    end

    methods 
        function obj = SimulationPetrolStation(ToServe, Rate1, Rate2, Rate3, MaxPlaces, NumLines, NumPumps)
            obj.IdClient = 0;
            obj.ClientQueue = Queue(MaxPlaces);
            obj.ServiceQueue = Queue();
            obj.Clock = 0;
            obj.BlockClients = false(1, 2);
            obj.ToServe = ToServe;
            obj.Arrival = ClientArrivalStation(Rate1, @(x)  poissrnd(x));
            obj.FuelService = FuelServiceStation(Rate2, @(x) poissrnd(x),inf);
            obj.CashService = CashServiceStation(Rate3, @(x) poissrnd(x),inf);
            obj.WaitingTimeCash = WaitingTime();
            obj.WaitingTimeExit = WaitingTime();
            obj.Pumps = Pumps(NumLines, NumPumps);
        end


        function Simulazione(obj)
            while obj.ClientQueue.Served <= obj.ToServe
                obj.Clock = min([obj.Arrival.TimesList(1),obj.FuelService.TimesList(1),obj.CashService.TimesList(1)]);

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

                if obj.Clock == obj.FuelService.TimesList(1)
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
        end

        function UpdateIdClient(obj)
            obj.IdClient = obj.IdClient + 1;
        end

    end
end