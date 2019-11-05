classdef testingDirect < handle
    %TESTINGDIRECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        listPtr
        arr = []
    end
    
    methods
        function ts = testingDirect( size)
            ts.arr = zeros(1, size)
            ts.listPtr = 1;
        end
        
        function ts = addEle(ts, in)
            ts.arr(:,1) = in;
        end
        
        
    end
    
end

