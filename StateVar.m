classdef StateVar < handle

    properties
        Times
        Values
        CurrentState
    end

    methods
        function obj = StateVar()
            obj.Times = [];
            obj.Values  = [];
            obj.CurrentState = 0;
        end
    end

    methods (Abstract)
        Update()

        CleanState()

        finalState = EvaluateFinalState()
    end

end