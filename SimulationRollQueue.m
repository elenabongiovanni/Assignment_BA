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
    % rate_arrival
    % distribution_arrival
    % rate_service
    % distribution_service
    end

methods
    function obj = SimulationRollQueue(Queue,ToServe,Rate1,Rate2)
            obj.MyQueue = Queue;
            obj.Buffer = Queue;
            obj.Clock = 0;
            obj.ToServe = ToServe;
            obj.Arrival = Events(Rate1, @(x)  poissrnd(x));
            obj.Roll = Events(Rate2, @(x) exprnd(x));
            obj.ResidualDemand = [];
            obj.JoinTime = [];
   
    end
    
    % function ManageToServe(obj)
    % 
    % end

    function [totalWaitingTime] = EvaluatePolicy(obj)
         while obj.MyQueue.Served <= obj.ToServe
            if obj.Rolls.Next <= obj.Arrival.Next  % manage roll completion event
                obj.Clock = obj.Rolls.Next;
                if ~ isempty(obj.ResidualDemand)  % customer in queue, serve demand
                    obj.ResidualDemand(1) = obj.ResidualDemand(1)-1;
                    if obj.ResidualDemand(1) == 0 % service completed
                        totalWaitingTime = totalWaitingTime + (obj.clock - obj.JoinTime(1)); % 
                        obj.MyQueue.AddServed(); % ho servito un altro cliente 
                    
                        % dequeue
                        obj.JoinTime(1) = [];
                        obj.ResidualDemand(1) = [];
                    end
                else % no customer, increase buffer count
                    buffer = buffer+1;
                end
                if buffer == maxPlaces
                    blocked = true;
                    obj.Rolls.Next = inf;
                else
                    obj.Rolls.GenerateNext();
                end
            else % manage customer arrival event
                obj.Clock = obj.Arrival.Next ;
                obj.Arrival.GenerateNext();
                demand = unidrnd(maxDemand);
                if ~ isempty(obj.ResidualDemand) % join queue
                    obj.ResidualDemand(end+1) = demand;
                    obj.JoinTime(end+1) = obj.Clock;
                else % no one in queue, grab some roll
                    if buffer >= demand
                        buffer = buffer - demand;
                        count = count + 1; % waiting time is zero
                    else % wait for more rolls
                        demand = demand - buffer;
                        buffer = 0;
                        obj.ResidualDemand(1) = demand;
                        obj.JoinTime(1) = obj.Clock;
                    end
                    if blocked % unblock roll preparation
                        blocked = false;
                        nextRoll = obj.clock + unifrnd(lowTime,highTime);
                    end
                end
            end % main IF
        end % while
        fprintf(1,'average waiting time = %.2f\n', totalWaitingTime/count);
    end



end

end