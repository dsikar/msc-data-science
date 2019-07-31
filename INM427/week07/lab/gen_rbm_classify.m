function output = gen_rbm_classify(model,dat)
% classify by sampling
% sontran 2013
lNum = size(model.U,1);
sNum = size(dat,1);
labP = 0.5*ones(sNum,lNum);
hidP = logistic(bsxfun(@plus,dat*model.W + labP*model.U,model.hidB));
hidPs = hidP>rand(size(hidP));
hidNs = hidPs;
%% gibb sampling
%for g=1:gNum
    visN = logistic(bsxfun(@plus,hidNs*model.W',model.visB));
    visNs = visN>rand(size(visN));
    output = softmax(exp(bsxfun(@plus,hidNs*model.U',model.labB)));
%    hidN = logistic(visNs*model.W + model.U(output,:) + repmat(model.hidB,sNum,1));
%    hidNs = hidN>rand(size(hidN));
%end 
end