function model = gen_rbm_train(conf)
% Train generative RBM with label
% sontran2013
%% load file
dat = get_data_from_file(conf.trn_dat_file);
%% setting up
hidNum = conf.hidNum;
[SZ,visNum] = size(dat);

model.W = 0.1*randn(visNum,hidNum);
model.U = [];

model.visB = zeros(1,visNum);
model.hidB = zeros(1,hidNum);
model.labB = [];

WD    = zeros(size(model.W));
visBD = zeros(size(model.visB));
hidBD = zeros(size(model.hidB));

bNum = conf.bNum;
if bNum==0, bNum=ceil(SZ/conf.sNum); end
%% running
lr = conf.params(1);
for e=1:conf.eNum;
    inx = randperm(SZ);    
    
    res_e = 0;  % Reconstruction error
    spr_e = 0;  % Sparsity
    
    if exist('conf.lr_decay','var'), lr=lr/conf.lr_decay^e;
    elseif e==conf.N+1, lr = conf.params(2); end
    
    for b=1:bNum
        iiii = inx((b-1)*conf.sNum+1:min(b*conf.sNum,SZ));
        visP = dat(iiii,:);
        sNum = size(visP,1);
        
        hidP = logistic(visP*model.W + repmat(model.hidB,sNum,1));
        hidPs = hidP>rand(size(hidP));
        hidNs = hidPs;
        %% gibb sampling
        for g=1:conf.gNum
            visN = logistic(bsxfun(@plus,hidNs*model.W',model.visB));
            visNs = visN>rand(size(visN));
            
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
            if strcmp(conf.sparsity,'EMIN')
                expectation_min;
            end
           model.W = model.W + lr*w_diff;
           model.hidB = model.hidB + lr*h_diff;
        end
    end
    fprintf('[Epoch %.3d] res_e = %.5f || spr_e = %.3f \n',e,res_e/bNum,spr_e/bNum);
    if exist('conf.vis_dir','var')
        save_images(visN,100,28,28,strcat(conf.vis_dir,num2str(e),'.bmp'));
    end
end   
end