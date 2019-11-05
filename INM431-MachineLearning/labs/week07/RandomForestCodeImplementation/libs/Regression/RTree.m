classdef RTree < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant = true)
        C_NUM_FEATURES = 1;
        C_THRESHOLD_IT = 10;
    end
    properties
        m_treetable;
        m_leaves;
        
        % params
        m_minSamples;
        m_maxDepth;
        m_numNodes;
        m_numLeaves;
        m_sizeOneNode;
        m_curNodeIndex;
    end
    
    methods
        
        % constructor
        function RT = RTree(minSamp, maxDepth)
            RT.m_minSamples = minSamp;
            RT.m_maxDepth = maxDepth;
            RT.m_numLeaves = 1;
            
            RT.m_sizeOneNode = RT.C_NUM_FEATURES*2 + 1 + 2; % +2 for store address to next leaves
            RT.m_numNodes = int32(2^(maxDepth+1)) - 1; %get max number of nodes
            
            RT.m_treetable = double(zeros(RT.m_sizeOneNode, RT.m_numNodes));
            RT.m_leaves = leafNode.empty(2^RT.m_maxDepth,0);
            
            RT.m_curNodeIndex = 1;
        end
        
        function RT =  trainTree(RT, inData, inLabel)
            rng('shuffle');
            
            fprintf(' Growing tree ... \n');
            
            RT = growTree(RT, inData, inLabel, 1, 1);
            
            % after growing the tree take back the memory
            RT.m_treetable(:, RT.m_curNodeIndex+1:end) = [];
        end
        
        function RT =  growTree(RT, inData, inLabel, node, depth)
            
            % get number of samples in the data
            numSamples = size(inLabel, 2);
            
            % check if reached max depth and contains data
            if(depth >= RT.m_maxDepth  &&  size(inData, 2))
                fprintf('Reached Maximum Depth. Creating leaf node... \n ');
                RT = RT.makeLeaf(inData, inLabel, node);
            end
            
            leftPartition = []; rightPartition = []; leftPartitionLabel = []; rightPartitionLabel =  [];
            %bestThreshold = 0;
            %partitionMap = double(zeros(1, numSamples));
            [partitionMap, bestThreshold, ret] = RT.optimizeTest(inData, inLabel);
            if(ret)
                RT.m_treetable(1, node) = -1;
                for t = 1:RT.C_NUM_FEATURES*2
                    RT.m_treetable(t+1, node) = bestThreshold(1,t);
                end
                
                numOfRight = sum(partitionMap);
                numOfLeft = numSamples - numOfRight;
                
                leftPartition = double(zeros(size(inData,1), numOfLeft));
                leftPartitionLabel = double(zeros(size(inLabel,1), numOfLeft));
                
                rightPartition = double(zeros(size(inData,1), numOfRight));
                rightPartitionLabel = double(zeros(size(inLabel,1), numOfRight));
                
                % copy the data into left and right
                lIdx = 1; rIdx = 1;
                for i = 1:numSamples
                    if(partitionMap(1, i) == false)
                        leftPartition(:, lIdx) = inData(:, i);
                        leftPartitionLabel(:, lIdx) = inLabel(:, i);
                        lIdx = lIdx + 1;
                    else
                        rightPartition(:, rIdx) = inData(:, i);
                        rightPartitionLabel(:, rIdx) = inLabel(:, i);
                        rIdx = rIdx + 1;
                    end
                end
                
                % Grow tree towards left or make leaf
                if(size(leftPartition, 2) > RT.m_minSamples)
                    fprintf('Left Branch: %d Node: %d Depth: %d \n ' , size(leftPartition,2), 2*node +1, depth + 1);
                    RT.m_curNodeIndex = RT.m_curNodeIndex + 1;
                    RT.m_treetable(RT.C_NUM_FEATURES*2 +2, node) = RT.m_curNodeIndex;
                    RT = RT.growTree( leftPartition, leftPartitionLabel, RT.m_curNodeIndex, depth + 1);
                else
                    RT.m_curNodeIndex = RT.m_curNodeIndex + 1;
                    RT.m_treetable(RT.C_NUM_FEATURES*2 +2, node) = RT.m_curNodeIndex;
                    RT = RT.makeLeaf( leftPartition, leftPartitionLabel, RT.m_curNodeIndex);
                end
                
                % Grow tree towards right or make leaf
                if(size(rightPartition, 2) > RT.m_minSamples)
                    fprintf('Right Branch: %d Node: %d Depth: %d \n ' , size(rightPartition,2), 2*node +2, depth + 1);
                    RT.m_curNodeIndex = RT.m_curNodeIndex + 1;
                    RT.m_treetable(RT.C_NUM_FEATURES*2 + 3, node) = RT.m_curNodeIndex;
                    RT = RT.growTree( rightPartition, rightPartitionLabel, RT.m_curNodeIndex , depth + 1);
                else
                    RT.m_curNodeIndex = RT.m_curNodeIndex + 1;
                    RT.m_treetable(RT.C_NUM_FEATURES*2 + 3, node) = RT.m_curNodeIndex;
                    RT = RT.makeLeaf( rightPartition, rightPartitionLabel, RT.m_curNodeIndex);
                end
            else
                fprintf('Could not find the best split, making leaf....\n');
                RT = RT.makeLeaf( inData, inLabel, node);
            end
            
            
        end
        
        % function to create a leafnode
        function RT =  makeLeaf(RT, inData, inLabel, node)
            %             fprintf('Making leaf node\n');
            RT.m_treetable(1, node) = RT.m_numLeaves;
            RT.m_leaves( RT.m_numLeaves).m_cov = cov(inLabel');
            RT.m_leaves( RT.m_numLeaves).m_mean = mean(inLabel');
            
            RT.m_numLeaves = RT.m_numLeaves + 1;
        end
        
        % function to optimise the given test at each split node
        function [partitionMap, bestThreshold, ret] = optimizeTest(RT, inData, inLabel)
            % for now using this value for negative lowest starting number
            bestThreshold = [];
            bestSplit = -10000.0;
            ret = false;
            bestTest = [];
            returnPartitionMap =[];
            for i = 1:10
                tmpTest = RT.generateTest(size(inData, 1));
                retFeatures = RT.evaluateTest(inData, tmpTest);
                
                minVal = min(retFeatures,[], 2);
                maxVal = max(retFeatures, [], 2);
                
                checkValsRange = true;
                for cI = 1:RT.C_NUM_FEATURES
                    checkValsRange = (checkValsRange & (maxVal(cI, 1) - minVal(cI, 1))>0);
                end
                
                if(checkValsRange)
                    for j = 1:RT.C_THRESHOLD_IT
                        tempThreshold = zeros(size(minVal));
                        %partitionMap = zeros(1, size(inData,2));
                        for jj = 1:size(tempThreshold,1)
                            tempThreshold(jj, 1) =  minVal(jj,1) + (maxVal(jj,1)-minVal(jj,1))*rand;
                        end
                        partitionMap = RT.split(retFeatures, tempThreshold);
                        
                        checkSum = sum(partitionMap);
                        if(checkSum > 5  &&  (size(partitionMap,2)-checkSum) > 5)
                            score = RT.measureInformationGain(inLabel, partitionMap);
                            %                             fprintf('Information Gain: %f \n', score);
                            if(score > bestSplit)
                                ret = true;
                                bestSplit = score;
                                returnPartitionMap = partitionMap;
                                bestTest = tmpTest;
                                
                                bestThreshold = tempThreshold;
                            end
                        end
                    end
                end
                
            end
            partitionMap = returnPartitionMap;
            tempCpy = bestThreshold;
            bestThreshold = zeros(1, RT.C_NUM_FEATURES);
            
            if(ret)
                for i = 1:RT.C_NUM_FEATURES*2
                    if(i <= RT.C_NUM_FEATURES)
                        bestThreshold(1, i) = bestTest(i);
                    else
                        bestThreshold(1, i) = tempCpy(i-RT.C_NUM_FEATURES, 1);
                    end
                end
            end
            
            
        end
        
        % function to generate a test
        function test = generateTest(RT, lengthVec)
            test = zeros(1, RT.C_NUM_FEATURES);
            for i = 1: RT.C_NUM_FEATURES
                %                     test(i) = mod(rand, lengthVec);
                test(i) = randi(lengthVec);
                
            end
        end
        
        % function to evaluate the generated test
        function retFeatures =  evaluateTest(RT, inData, temp)
            retFeatures = zeros(RT.C_NUM_FEATURES, size(inData,2));
            
            for i = 1:size(inData,2)
                for j = 1: RT.C_NUM_FEATURES
                    retFeatures(j,i) = inData(temp(j), i);
                end
            end
        end
        
        % function to split at each split node
        function partitionMap = split(RT, selFeatures, cThreshold)
            partitionMap = zeros(1, size(selFeatures,2));
            for i = 1: size(selFeatures, 2)
                validationCheckL = true;
                
                for j = 1:size(selFeatures, 1)
                    validationCheckL = validationCheckL & (selFeatures(j,i) < cThreshold(j,1));
                end
                
                if(~validationCheckL)
                    partitionMap(1,i) = 1;
                end
            end
        end
        
        % function to measure the information gain
        function iG = measureInformationGain(RT, inLabel, partitionMap)
            totalNum = size(inLabel,2);
            numOfRight = sum(partitionMap);
            numOfLeft = totalNum - numOfRight;
            
            wl = numOfLeft/totalNum;
            wr = numOfRight/totalNum;
            
            allCov = cov(inLabel');
            
            Pl = zeros(size(inLabel, 1), numOfLeft);
            Pr = zeros(size(inLabel, 1), numOfRight);
            
            rIdx = 1; lIdx = 1;
            
            for i = 1:totalNum
                if(partitionMap(1, i) == 0 )
                    Pl(:, lIdx) = inLabel(:,i);
                    lIdx = lIdx + 1;
                else
                    Pr(:, rIdx) = inLabel(:,i);
                    rIdx = rIdx + 1;
                end
            end
            
            leftCov = cov(Pl');
            rightCov = cov(Pr');
            
            iG = log(det(allCov)) - wr*log(det(rightCov)) - wl*log(det(leftCov));
            
            if(isinf(iG))
                iG = 0;
            end
        end
        
        %function was named regression in previous implementation
        function leafNode = predictTree(RT, inData)
            idxNode = 1;
            
            % -1 means that it is a leaf node
            while(RT.m_treetable(1, idxNode) == -1)
                isLeft = true;
                % apply test
                
                for i = 1: RT.C_NUM_FEATURES
                    isLeft = isLeft & (inData(RT.m_treetable(i+1, idxNode), 1) < RT.m_treetable(i+ RT.C_NUM_FEATURES+1, idxNode));
                end
                
                if(isLeft)
                    % move to left node
                    idxNode = RT.m_treetable(RT.C_NUM_FEATURES*2 +2, idxNode);
%                     idxNode = 2*idxNode + 1;
                else
                    % move to right node
                    idxNode = RT.m_treetable(RT.C_NUM_FEATURES*2 +3, idxNode);
                end
            end
            
            % using index stored in tree table to return the cooresponding
            % leafnode
            leafNode = RT.m_leaves(RT.m_treetable(1, idxNode));
        end
    end
end
