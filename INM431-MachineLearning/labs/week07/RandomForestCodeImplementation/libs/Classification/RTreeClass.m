classdef RTreeClass < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    properties(Constant = true)
        C_NUM_FEATURES = 2;
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
        
        %clf
        m_categories;
    end
    
    methods
        
        % constructor
        function RT = RTreeClass(minSamp, maxDepth)
            RT.m_minSamples = minSamp;
            RT.m_maxDepth = maxDepth;
            RT.m_numLeaves = 1;
            
            RT.m_sizeOneNode = RT.C_NUM_FEATURES*2 + 1 + 2; % +2 for store address to next leaves
            RT.m_numNodes = int32(2^(maxDepth+1)) - 1; %get max number of nodes 2^11 - 1 = 2047
            
            RT.m_treetable = double(zeros(RT.m_sizeOneNode, RT.m_numNodes));
            RT.m_leaves = leafNodeHist.empty(2^RT.m_maxDepth,0);
            
            RT.m_curNodeIndex = 1;
        end
        
        function RT =  trainTree(RT, inData, inLabel)
            rng('shuffle'); % doc rgn ~ Control random number generation
            
            RT.m_categories = unique(inLabel); % RT.m_categories ans = 1     2     3     4
            fprintf(' Growing tree ... \n');
            
            RT = growTree(RT, inData, inLabel, 1, 1);
            
            % after growing the tree take back the memory
            RT.m_treetable(:, RT.m_curNodeIndex+1:end) = [];
            RT.m_numNodes = RT.m_curNodeIndex;
        end
        
        function RT =  growTree(RT, inData, inLabel, node, depth)
            
            % get number of samples in the data
            numSamples = size(inLabel, 2);
            
            % check if reached max depth and contains data
            if(depth >= RT.m_maxDepth  &&  size(inData, 2)) % (shortcut) bitwise AND, return true (1) if both arguments > 1
                fprintf('Reached Maximum Depth. Creating leaf node... \n ');
                RT = RT.makeLeaf(inData, inLabel, node);
            end
            
            leftPartition = []; rightPartition = []; leftPartitionLabel = []; rightPartitionLabel =  [];
            %bestThreshold = 0;
            %partitionMap = double(zeros(1, numSamples));
            [partitionMap, bestThreshold, ret] = RT.optimizeTest(inData, inLabel);
            if(ret) % perhaps bestSplitFound would be a better variable name for ret
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
            
            RT.m_leaves(RT.m_numLeaves).m_hist = zeros(2,size( RT.m_categories, 2));
            
            tCount = 0;
            for i = 1:size(RT.m_categories,2)
                count = size(inLabel(find(inLabel==RT.m_categories(1,i))),2);
                RT.m_leaves(RT.m_numLeaves).m_hist(1,i) = RT.m_categories(1,i);
                RT.m_leaves(RT.m_numLeaves).m_hist(2,i) = count;
                
                tCount = tCount + count;
            end
            RT.m_leaves(RT.m_numLeaves).m_hist(2,:) = RT.m_leaves(RT.m_numLeaves).m_hist(2,:)/tCount;
            
%             RT.m_leaves( RT.m_numLeaves).m_cov = cov(inLabel');
%             RT.m_leaves( RT.m_numLeaves).m_mean = mean(inLabel');
            
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
                % does happen
                % if (min(retFeatures(1,1:end)) ~= min(retFeatures(2,1:end))),
                %     disp('*********** min(retFeatures(1,1:end) != min(retFeatures(2,1:end)) ************');
                % end; 
                minVal = min(retFeatures,[],2);
                maxVal = max(retFeatures,[],2);
                
                checkValsRange = true;
                for cI = 1:RT.C_NUM_FEATURES
                    checkValsRange = (checkValsRange & (maxVal(cI, 1) - minVal(cI, 1))>0);
                end
                
                if(checkValsRange)
                    for j = 1:RT.C_THRESHOLD_IT % iterate RT.C_THRESHOLD_IT times, RTreeClass constant, times
                        tempThreshold = zeros(size(minVal));
                        %partitionMap = zeros(1, size(inData,2));
                        for jj = 1:size(tempThreshold,1) % set threshold at some random level between minVal and maxVal
                            tempThreshold(jj, 1) =  minVal(jj,1) + (maxVal(jj,1)-minVal(jj,1))*rand;
                        end 
                        partitionMap = RT.split(retFeatures, tempThreshold); 
                        % partitionMap contains If one of either row values in retFeatures is below threshold for row, set validation to false
                        checkSum = sum(partitionMap); % Sum all one's
                        % If there are more than 5 columns with feature values greater or equal to threshold 
                        % And the difference between the number of columns
                        % in partitionMap minus the checksum, i.e. number
                        % of zeros, is also greater than 5, compute the
                        % information gain (score in this case), % 5 is a magic number
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
                test(i) = randi(lengthVec); % doc randi ~ Uniformly distributed pseudorandom integers
                
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
        % Input parameters:
        %   selFeatures: matrix of features
        %   cThreshold: threshold row vector
        function partitionMap = split(RT, selFeatures, cThreshold)
            partitionMap = zeros(1, size(selFeatures,2));
            % loop through selFeatures, performing a validation check on
            % both rows against the thresholds. If one of row values is
            % below threshold, set validation to false
            for i = 1: size(selFeatures, 2)
                validationCheckL = true;
                
                for j = 1:size(selFeatures, 1) 
                    % e.g. First pass:
                    % validationCheckL = true & (780.4629 < 300.4446) ~ evaluates to false
                     % e.g. Second pass:
                    % validationCheckL = false & (780.4629 < 300.4446) ~ evaluates to false whatever the value of selFeatures(j,i)                  
                    % NB sum(selFeatures(1,:) ~= selFeatures(2,:)) = 0, all
                    % cThreshold(1,1) == cThreshold(2,1) in this case, not always the case
                    validationCheckL = validationCheckL & (selFeatures(j,i) < cThreshold(j,1));
                end
                % if at least one feature is greater or equal to threshold,
                % validationCheckL will evaluate to false, and
                % ~validationCheckL will evaluate to true, in the latter case, set split partition map cell to 1
                if(~validationCheckL)
                    partitionMap(1,i) = 1;
                end
            end
        end % size(partitionMap) ~ 256, sum(partitionMap(1,:)) ~ 128, splitting down the middle
        
        % function to measure the information gain
        function iG = measureInformationGain(RT, inLabel, partitionMap) 
            totalNum = size(inLabel,2);
            numOfRight = sum(partitionMap); % number of 1's
            numOfLeft = totalNum - numOfRight; % number of 0's
            % left and right fractions
            wl = numOfLeft/totalNum;
            wr = numOfRight/totalNum;
            % compute covariance of target label values (?)
            allCov = cov(inLabel'); % doc cov, covariance
            % empty vector of zeros
            Pl = zeros(size(inLabel, 1), numOfLeft);
            Pr = zeros(size(inLabel, 1), numOfRight);
            % create a 
            rIdx = 1; lIdx = 1;
            
            for i = 1:totalNum % keep track of both indexes, updating the appropriate partition vector
                if(partitionMap(1, i) == 0)
                    Pl(:, lIdx) = inLabel(:,i);
                    lIdx = lIdx + 1;
                else
                    Pr(:, rIdx) = inLabel(:,i);
                    rIdx = rIdx + 1;
                end
            end
            % compute covariance on each, left and right label vector
            % (why are we computing covariance of categorical data?)
            leftCov = cov(Pl');
            rightCov = cov(Pr');
            % calculate information gain, since allCov, rightCov and
            % leftCov are scalars, obtained from vector inLabel,
            % calculating the determinant of a 1 x 1 matrix may be an
            % overhead - in class we used log2,(why log10 here?)
            iG = log(det(allCov)) - wr*log(det(rightCov)) - wl*log(det(leftCov)); % e.g. = 0.1637
            % from Mitchell 3.3 and 3.7, pg. 57 and 58
            % Entropy(S) = SUM i=1 to c of -pi log base 2 of pi
            % where pi is the proportion of S belonging to class i
            % Proportions are wl and wr
            % Entropy(S) =  -wl*log2(wl)-wr*log2(wr)
            % Entropy(S) = 0.9978
            % Gain(S,A) is identically equal to Entropy(S) - SUM for all v
            % member of values(A) (|Sv|/|S|) * Entropy(Sv)  
            % where values(A) is the set of all possible values for attribute A, and Sv is the
            % subset of S for which attribute A has value v (i.e., Sv = {s ismember S|A(s) = v})
            % NB Here the left and right are being treated as classes
            % Gain(S,A) = Entropy(S) - (wl*Entropy(wl) + wr*Entropy(wr))
            % Entropy(ws) = -wl*log2(wl) = 0.5110
            % Entropy(wr) = -wr*log2(wr) = 0.4868
            % Gain(S,A) = Entropy(S) - (0.4727*0.5110 + 0.5273*0.4868)
            % Gain(S,A) = 0.9978 - 0.4982
            % Gain(S,A) = 0.4996
            
            % Back to this algorithm, check for infinite Information Gain, could happen if Pl or Pr
            % have only one label. 
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
