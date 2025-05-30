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
        function obj = SimulationPetrolStation(ToServe,Rate1,Rate2,MaxPlaces, NumLines, NumPumps)
            obj.IdClient = 0;
            obj.ClientQueue = Queue(MaxPlaces);
            obj.ServiceQueue = Queue();
            obj.Clock = 0;
            obj.ToServe = ToServe;
            obj.Arrival = ClientArrivalStation(Rate1, @(x)  poissrnd(x));
            obj.FuelService = FuelServiceStation(Rate2, @(x) exprnd(x),inf);
            obj.CashService = CashServiceStation(Rate2, @(x) exprnd(x),inf);
            obj.WaitingTimeCash = WaitingTime();
            obj.WaitingTimeExit = WaitingTime();
            obj.Pumps = Pumps(NumLines, NumPumps);
        end


        function Simulazione(obj)
            while obj.ClientQueue.Served <= obj.ToServe
                min = min(obj.Arrival.Next,obj.FuelService.Next,obj.CashService.Next);

                if min == obj.Arrival.Next
                    obj.Arrival.Manage(obj);
                end

                if min == obj.FuelService.Next
                    obj.FuelService.Manage(obj);
                end

                if min == obj.CashService.Next
                    obj.CashService.Manage(obj);
                end
                
                obj.Pumps.Update(obj);
                
            end
        end

        function UpdateIdClient(obj)
            obj.IdClient = obj.IdClient + 1;
        end

    end
end