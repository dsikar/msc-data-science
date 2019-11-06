classdef RForest < handle
    %RForest Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        m_decisionForest;
        m_numOfTrees;
    end
    
    methods
        function RT = RForest(numTrees)
             if ~exist('numTrees', 'var')
                 %giving default number for trees, if not given
                numTrees = 10;
             end
             RT.m_numOfTrees = numTrees;
             
             RT.m_decisionForest = RTree.empty(RT.m_numOfTrees,0);
        end
        
        function RT = trainRF(RT, inData, inLabel)
            %matlabpool open local 4
            for i = 1:RT.m_numOfTrees
                [trainData, trainLabel] = baggingFunction(RT,inData, inLabel);
                RT.m_decisionForest(i) = RTree(20, 10);
                RT.m_decisionForest(i).trainTree(trainData, trainLabel);
            end 
            %matlabpool close
        end
        
        function lNode = predictRF(RT, inData)
            lNode = leafNode;
            %tNode = [];
            for i = 1: RT.m_numOfTrees
                tNode = RT.m_decisionForest(i).predictTree(inData);
                
                if( i == 1 )
                    lNode = tNode;
                else
                    lNode.m_cov = lNode.m_cov + tNode.m_cov;
                    lNode.m_mean = lNode.m_mean + tNode.m_mean;
                end
            end
            
            lNode.m_cov = lNode.m_cov/RT.m_numOfTrees;
            lNode.m_mean = lNode.m_mean/RT.m_numOfTrees;
                    
        end
        
        function [outData, outLabel] = baggingFunction(RT, inData, inLabel, inRatio)
             if ~exist('inRatio', 'var')
                 %giving default number for ratio, if not given
                inRatio = 0.8;
             end
             numOfSamples = size(inLabel,2);
             selectedNumSamples = numOfSamples * inRatio;
             
             % get index of samples 
             [~, idx] = datasample(inLabel, selectedNumSamples, 2, 'Replace', true);
             
             % return the selected
             outData = inData(:, idx);
             outLabel = inLabel(:, idx);
        end
        
%         function randSamp
            
    end
    
end

