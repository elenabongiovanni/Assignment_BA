classdef SimulationRollQueue < handle 

    properties 
        MyQueue
        Buffer
        Clock
        ToServe
        Arrival
        Roll
        ResidualDemand
        JoinTime
        WaitingTime
        MaxDemand = 3
        Count = 0
        IdClient = 0
        IdRoll = 0
        % rate_arrival
        % distribution_arrival
        % rate_service
        % distribution_service
    end

methods
    function obj = SimulationRollQueue(ToServe,Rate1,Rate2)
            obj.MyQueue = Queue();
            obj.Buffer = Queue(6);
            obj.Clock = 0;
            obj.ToServe = ToServe;
            obj.Arrival = ClientArrivalRoll(Rate1, @(x)  exprnd(x));
            obj.Roll = ServiceRoll(Rate2, @(x) exprnd(x));
            obj.ResidualDemand = [];
            obj.JoinTime = [];
            obj.WaitingTime = WaitingTime();
   
    end
   

    function Simulazione(obj)
        while obj.MyQueue.Served < obj.ToServe
            disp(obj.MyQueue.Served);
            disp(obj.Roll.Next)
            disp(obj.Arrival.Next)
            
            if obj.Roll.Next <= obj.Arrival.Next
                % disp("panino pronto")
                obj.Clock = obj.Roll.Next;
                obj.Roll.Manage(obj);

            else
                %disp("arrivo cliente")
                obj.Clock = obj.Arrival.Next;
                obj.Arrival.Manage(obj);
            end

            fprintf('persone in coda: %d\n', obj.MyQueue.NumInQueue)
            fprintf('panini nel buffer: %d\n', obj.Buffer.NumInQueue)

        end
    end


end

end