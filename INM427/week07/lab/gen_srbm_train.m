function model = gen_srbm_train(conf,trn_dat)
% sontran2013
%% setting up
hidNum = conf.hidNum;
visNum = size(trn_dat,2);
sz  = size(trn_dat,1);
if conf.bNum == 0
    bNum = ceil(sz/conf.sNum);
else
    bNum = conf.bNum;
end

model.W = 0.01*randn(visNum,hidNum);

model.visB = zeros(1,visNum);
model.hidB = zeros(1,hidNum);

WD    = zeros(size(model.W));
visBD = zeros(size(model.visB));
hidBD = zeros(size(model.hidB));

%% running
lr = conf.params(1);
for e=1:conf.eNum;
    e
    inx = randperm(size(trn_dat,1));    
    
    res_e = 0;    
    spr_e = 0;

    for b=1:bNum
        iiii = inx((b-1)*conf.sNum+1:min(b*conf.sNum,sz));                
        visP = trn_dat(iiii,:);
        sNum = size(visP,1);
        
        hidI = (visP*model.W +  repmat(model.hidB,sNum,1));
        hidP = logistic(hidI);
        hidPs = hidP>rand(size(hidP));
        hidNs = hidPs;
        %% gibb sampling
        for g=1:conf.gNum
            if conf.vis==1
                visN  = (hidNs*model.W' + repmat(model.visB,sNum,1));
                visNs = visN + randn(sNum,visNum);           
            else
                visN = logistic(bsxfun(@plus,hidNs*model.W',model.visB));
                visNs = visN>rand(size(visN));            
            end
            
            hidN = logistic(visNs*model.W + repmat(model.hidB,sNum,1));            
            hidNs = hidN>rand(size(hidN));
        end        
        res_e = res_e + sum(sqrt(sum((visP - visNs).^2,2)/visNum),1)/sNum;
        
        %% updating
        w_diff = (visP'*hidP - visNs'*hidN)/sNum;
        WD = lr*(w_diff - conf.params(4)*model.W) + conf.params(3)*WD;
        model.W = model.W + WD;
              
        
        visBD = lr*sum(visP - visNs,1)/sNum + conf.params(3)*visBD;
        model.visB  = model.visB + visBD;
        
        hidBD = lr*sum(hidPs - hidNs,1)/sNum + conf.params(3)*hidBD;
        model.hidB  = model.hidB + hidBD;                        
        %% Sparsity contrains
        if conf.lambda >0
           %hidI = (visP*model.W +  repmat(model.hidB,sNum,1));           
           pppp = (conf.p - sum(hidP,1)/sNum);           
           model.hidB = model.hidB + lr*conf.lambda*(pppp.*(sum((hidP.^2).*exp(-hidI),1)/sNum));           
           spr_e = spr_e + sum((conf.p - mean(hidP)).^2,2);
        end
    end   
    fprintf('[Epoch %.3d] res_e = %.5f | spr_e = %.5f \n',e,res_e/bNum,spr_e/bNum);  
    if isnan(res_e), return; end
        
end   

end