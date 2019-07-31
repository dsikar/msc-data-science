function output = dis_rbm_classify(model,dat)
% Classify by max energy
% sontran2013
SZ     = size(dat,1);
num    = 1000; % Increase this value according to the GPU to improve performance
bNum   = ceil(SZ/num);
hidNum = size(model.W,2);
lNum   = size(model.U,1);
%size(repmat(dat*model.W + repmat(model.hidB,sNum,1),[1,1,lNum]))
%size(repmat(reshape((eye(lNum)*model.U)',[1 hidNum lNum]),[sNum,1,1])) 
output = 0*dat(:,1);
for b=1:bNum
    sInx = (b-1)*num+1;
    eInx = min(b*num,SZ);
    ddd = dat(sInx:eInx,:);
    sNum = size(ddd,1);
    xxxx = repmat(ddd*model.W + repmat(model.hidB,sNum,1),[1,1,lNum]) + ...
        repmat(reshape((eye(lNum)*model.U)',[1 hidNum lNum]),[sNum,1,1]);   
    xxxx = reshape(sum(log(1+exp(xxxx)),2),[sNum lNum]);
    [~,outp] = max(xxxx,[],2);
    output(sInx:eInx) = outp;
end
end