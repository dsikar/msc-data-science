% script to compute sparsity using Expectaion minimization (Lee's)
% require  - model: W, hidB, visB
%          - conf (model & training settings)
%          - input data: visP
%          - batch size: sNum
% return:  - updated model
%          - spasiry error: spr_e
% Son T - 2014

hidI = bsxfun(@plus,visP*model.W,model.hidB);
hidN = logistic(hidI);
hspr = hspr + sum((conf.p - mean(hidN)).^2,2);
%current sparsity
pppp = (conf.p - mean(hidN));
if isfield(conf,'sparse_w')
    w_diff = lr*conf.lambda*(repmat(pppp,visNum,1).*(visP'*((hidN.^2).*exp(-hidI))));
else
    w_diff = 0;
end
h_diff = lr*conf.lambda*(pppp.*(sum((hidN.^2).*exp(-hidI),1)/sNum));           