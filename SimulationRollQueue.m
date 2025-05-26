classdef SimulationRollQueue < handle 

    properties 
    MyQueue
    clock
    toServe
    arrivals
    rolls
    residualDemand
    joinTime
    % rate_arrival
    % distribution_arrival
    % rate_service
    % distribution_service
    end

methods
    function obj = SimulationRollQueue(Queue,ToServe,Rate1,Rate2)
            obj.MyQueue = Queue;
            obj.clock = 0;
            obj.toServe = ToServe;
            obj.arrivals = Events(Rate1, @(x)  poissrnd(x));
            obj.rolls = Events(Rate2, @(x) exprnd(x));
            obj.residualDemand = [];
            obj.joinTime = [];
   
    end
    
    function ManageToServe(obj)
        
    end

    function [totalWaitingTime] = EvaluatePolicy(obj)
         while obj.MyQueue.Served <= obj.toServe
            if obj.rolls.Next <= obj.arrivals.Next  % manage roll completion event
                obj.clock = obj.rolls.Next;
                if ~ isempty(obj.residualDemand)  % customer in queue, serve demand
                    obj.residualDemand(1) = obj.residualDemand(1)-1;
                    if obj.residualDemand(1) == 0 % service completed
                        totalWaitingTime = totalWaitingTime + (obj.clock - obj.joinTime(1)); % 
                        obj.MyQueue.AddServed(); % ho servito un altro cliente 
                    
                        % dequeue
                        obj.joinTime(1) = [];
                        obj.residualDemand(1) = [];
                    end
                else % no customer, increase buffer count
                    buffer = buffer+1;
                end
                if buffer == maxPlaces
                    blocked = true;
                    obj.rolls.Next = inf;
                else
                    obj.rolls.GenerateNext();
                end
            else % manage customer arrival event
                obj.clock = obj.arrivals.Next ;
                obj.arrivals.GenerateNext();
                demand = unidrnd(maxDemand);
                if ~ isempty(obj.residualDemand) % join queue
                    obj.residualDemand(end+1) = demand;
                    obj.joinTime(end+1) = obj.clock;
                else % no one in queue, grab some roll
                    if buffer >= demand
                        buffer = buffer - demand;
                        count = count + 1; % waiting time is zero
                    else % wait for more rolls
                        demand = demand - buffer;
                        buffer = 0;
                        obj.residualDemand(1) = demand;
                        obj.joinTime(1) = obj.clock;
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