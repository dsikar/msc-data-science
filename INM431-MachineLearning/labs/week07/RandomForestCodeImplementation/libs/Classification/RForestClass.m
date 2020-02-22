classdef RForestClass < handle
    %RForest Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        m_decisionForest;
        m_numOfTrees;
    end
    
    methods
        % Argument: number of trees
        % Return type: struct
        %               m_numOfTrees: integer
        %               m_decisionForest:  
        function RT = RForestClass(numTrees)
             if ~exist('numTrees', 'var')
                 %giving default number for trees, if not given
                numTrees = 10;
             end
             RT.m_numOfTrees = numTrees;
             % Create empty array RTreeClass of size 0
             RT.m_decisionForest = RTreeClass.empty(RT.m_numOfTrees,0);
        end
        
        function RT = trainRF(RT, inData, inLabel, maxDepth)
            %matlabpool open local 4
            for i = 1:RT.m_numOfTrees % iterate through this loop, 
                % - each tree contains random 80% of training data (already in itself 80% sample of raw data)
                [trainData, trainLabel] = baggingFunction(RT,inData, inLabel); 
                % RT.m_decisionForest(i) = RTreeClass(20, 10);
                RT.m_decisionForest(i) = RTreeClass(20, maxDepth);
                RT.m_decisionForest(i).trainTree(trainData, trainLabel);
            end 
            %matlabpool close
        end
        
        function [pLabel, lNode] = predictRF(RT, inData)
            lNode = leafNodeHist;
            %tNode = [];
            for i = 1: RT.m_numOfTrees
                tNode = RT.m_decisionForest(i).predictTree(inData);
                
                if( i == 1 )
                    lNode = tNode;
                else
                    lNode.m_hist = lNode.m_hist + tNode.m_hist;
                end
            end
            
            lNode.m_hist = lNode.m_hist/RT.m_numOfTrees;
            [~, idx] = max(lNode.m_hist(2,:));
            pLabel = lNode.m_hist(1, idx);
        end
        % Document - input parameters, output parameters
        function [outData, outLabel] = baggingFunction(RT, inData, inLabel, inRatio)
            % doc exist ~ Check existence of variable, script, function, folder, or class
            % ~exist('RT', 'var') ans = logical 0 - RT exists as one of the
            % above in the present environment
            % ~exist('myvar', 'var') ans = logical 0 - my does not
             if ~exist('inRatio', 'var')
                 %giving default number for ratio, if not given
                inRatio = 0.8;
             end
             numOfSamples = size(inLabel,2);
             selectedNumSamples = numOfSamples * inRatio;
             
             % get index of samples 
             [~, idx] = datasample(inLabel, uint32(selectedNumSamples), 2, 'Replace', true);
             
             % return the selected
             outData = inData(:, idx);
             outLabel = inLabel(:, idx);
        end
        
%      function randSamp
            
    end
    
end

