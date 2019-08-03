function [model,vld_acc,tst_acc] = class_rbm_train(conf)
% Label-sparsity constrained RBM
% sontran2013
trn_dat = get_data_from_file(conf.trn_dat_file);
trn_lab = get_data_from_file(conf.trn_lab_file);

if isfield(conf,'gpu') && conf.gpu
    gpu = 1;
    trn_dat = gpuArray(trn_dat);
    trn_lab = gpuArray(trn_lab);
else 
    gpu = 0;
end

if ~isempty(conf.vld_dat_file)
    vld_dat = get_data_from_file(conf.vld_dat_file);
    vld_lab = get_data_from_file(conf.vld_lab_file);
    if gpu
        vld_dat = gpuArray(vld_dat);
        vld_lab = gpuArray(vld_lab);
    end
end

if isfield(conf,'tst_dat_file') && ~isempty(conf.tst_dat_file)
    tst_dat = get_data_from_file(conf.tst_dat_file);
    tst_lab = get_data_from_file(conf.tst_lab_file);
    if gpu
        tst_dat = gpuArray(tst_dat);
        tst_lab = gpuArray(tst_lab);
    end
end

%prepare
[SZ,visNum] = size(trn_dat);
hidNum = conf.hidNum;
labNum = size(unique(trn_lab),1);
bNum = conf.bNum;
if conf.bNum == 0, bNum   = round(SZ/conf.sNum); end

mmm = max(visNum,hidNum);
model.W    = (1/sqrt(mmm))*(2*rand(visNum,hidNum)-1);
mmm = max(labNum,hidNum);
model.U    = (1/sqrt(mmm))*(2*rand(labNum,hidNum)-1);

model.visB = 0.00*randn(1,visNum);
model.hidB = 0.00*randn(1,hidNum);
model.labB = 0.00*randn(1,labNum);

WD  = zeros(size(model.W));
UD  = zeros(size(model.U));
visBD = zeros(size(model.visB));
hidBD = zeros(size(model.hidB));
labBD = zeros(size(model.labB));

if gpu
    model.W    = gpuArray(model.W);
    model.U    = gpuArray(model.U);

    model.visB = gpuArray(model.visB);
    model.hidB = gpuArray(model.hidB);
    model.labB = gpuArray(model.labB);

    WD  = gpuArray(WD);
    UD  = gpuArray(UD);
    visBD = gpuArray(visBD);
    hidBD = gpuArray(hidBD);
    labBD = gpuArray(labBD);
end

lr = conf.params(1);
tic;
vld_best = 0;
es_count = 0;
acc_drop_count = 0;
vld_acc  = 0;
tst_acc  = 0;
e = 0;
running =1;


if ~isfield(conf,'N'), N=1; end

if ~isfield(conf,'class_type'), class_type=2; end

conf.dis = 1-conf.gen;

while running    
    e = e+1;
    inx = randperm(SZ);
    %dat = dat(inx,:);
    %lab = lab(inx);
    
    res_e = 0;
    trn_acc = 0;
    hspr  = 0;
    
    if isfield(conf,'lr_decay'), lr=lr/conf.lr_decay^e;
    elseif e==N+1, lr = conf.params(2); end
    for b=1:bNum
        w_diff = 0; u_diff = 0; v_diff = 0; h_diff = 0; l_diff = 0;
        iiii = inx((b-1)*conf.sNum+1:min(b*conf.sNum,SZ));
        visP = trn_dat(iiii,:);
        labP = trn_lab(iiii) + 1;
        
        sNum = size(visP,1);
        
        hidP = logistic(visP*model.W + model.U(labP,:) + repmat(model.hidB,sNum,1));
%         hidP = logistic(visP*model.W + repmat(model.hidB,sNum,1));
        hidPs = 1.0*(hidP>rand(size(hidP)));
        hidNs = hidPs;
        if conf.gen>0
            %% gibb sampling
            for g=1:conf.gNum
                visN = logistic(bsxfun(@plus,hidNs*model.W',model.visB));
                visNs = 1.0*(visN>rand(size(visN)));
                labN = softmax_(bsxfun(@plus,hidNs*model.U',model.labB));
                hidN = logistic(visNs*model.W + model.U(labN,:) + repmat(model.hidB,sNum,1));            
    %             hidN = logistic(visNs*model.W + repmat(model.hidB,sNum,1));
                hidNs = 1.0*(hidN>rand(size(hidN)));
            end        
            res_e = res_e + sum(sqrt(sum((visP - visNs).^2,2))/visNum,1)/sNum;
            %
    %        acc_e = acc_e + sum(sum(labP == labN))/sNum;
            %% updating from log-likelihood        
            w_diff = conf.gen*(visP'*hidP - visNs'*hidN)/sNum;        

            s_labP = discrete2softmax(labP,labNum);
            s_labN = discrete2softmax(labN,labNum);

            u_diff = conf.gen*(s_labP'*hidP - s_labN'*hidN)/sNum;                                
            v_diff = conf.gen*sum(visP - visNs,1)/sNum;               
            h_diff = conf.gen*sum(hidPs - hidNs,1)/sNum;                
            l_diff = conf.gen*sum(s_labP - s_labN,1)/sNum;
        
        end
        %% Label Sparsity constrains
        if conf.dis>0         
            [cprobs H] = con_probs(model.W,model.U,model.labB,model.hidB,visP);           
            
            H = logistic(H);
            hk_x = H.*repmat(reshape(cprobs,[sNum 1 labNum]),[1 hidNum 1]);
            e_hh = sum(hk_x,3);
            
            hhh = hidP - e_hh;
            
            w_diff = w_diff + conf.dis*(visP'*hhh)/sNum;      
            
            s_Y = discrete2softmax(labP,labNum);
            hy_x = H.*repmat(reshape(s_Y,[sNum 1 labNum]),[1 hidNum 1]);
            
            u_diff = u_diff + conf.dis*reshape(sum((hy_x-hk_x),1),[hidNum labNum])'/sNum;                        
            h_diff = h_diff + conf.dis*sum(hhh,1)/sNum;            
            l_diff = l_diff + conf.dis*sum(s_Y - cprobs,1)/sNum;                        
        end        
       
        % Updating
        WD = lr*(w_diff - conf.params(4)*model.W) + conf.params(3)*WD;
        model.W = model.W + WD;
        UD = lr*(u_diff - conf.params(4)*model.U) + conf.params(3)*UD;
        model.U = model.U + UD;
        visBD = lr*v_diff + conf.params(3)*visBD;
        model.visB = model.visB + visBD;
        hidBD = lr*h_diff + conf.params(3)*hidBD;
        model.hidB = model.hidB + hidBD;
        labBD = lr*l_diff + conf.params(3)*labBD;
        model.labB = model.labB + labBD;
        
        %% Hidden Sparsity contrains
        if conf.lambda >0 
            if strcmp(conf.sparsity,'EMIN')
                expectation_min;
            end
           model.W = model.W + lr*w_diff;
           model.hidB = model.hidB + lr*h_diff;
        end
        
        % Get training accuracy
        trn_acc = trn_acc + sum(labP == rbm_classify(model,visP,2))/sNum;
    end
    %output = rbm_classify(model,tst_dat,1); % classify using max-reconstruction probs
    %acc_r  = sum(sum(output==tst_lab+1))/size(tst_lab,1);
    if exist('vld_lab','var')
        output = rbm_classify(model,vld_dat,class_type); % classify using max-energy (cond probs) for validation set      
        vld_acc  = sum(sum(output==vld_lab+1))/size(vld_lab,1);
    end
    if exist('tst_lab','var')
        output = rbm_classify(model,tst_dat,class_type); % classify using max-energy (cond  probs) for test set
        tst_acc  = sum(sum(output==tst_lab+1))/size(tst_lab,1);
    end
    
    hspr = hspr/bNum;
    trn_acc= trn_acc/bNum; % training accuracy (aprx)
    
    fprintf('[Epoch %.4d] res_e = %.5f||sparsity=%.5f||trn_acc = %.5f ||vld_acc = %.5f || tst_acc = %.5f\n',...
        e,res_e, hspr,trn_acc,vld_acc,tst_acc);
    
    if isfield(conf,'plot')
        if ~exist('res_e_plot','var')
            res_e_plot = []; 
            trn_acc_plot = [];
            vld_acc_plot = [];
            sparse_plot  = [];
        end
        res_e_plot = [res_e_plot, res_e];
        trn_acc_plot = [trn_acc_plot, trn_acc];
        vld_acc_plot = [vld_acc_plot, vld_acc];
        sparse_plot = [sparse_plot, hspr];
    end
    
    if isfield(conf,'log_file')
        logging(conf.log_file,[e,res_e,hspr,trn_acc,vld_acc,tst_acc]);
    end
   
    if isfield(conf,'vis_dir')
        save_images(visN,100,conf.row,conf.col,strcat(conf.vis_dir,num2str(e),'.bmp'));
    end
    
    % PARAM DECAY
    if isfield(conf,'E_STOP_LR_REDUCE')
        if vld_acc<=vld_best
            acc_drop_count = acc_drop_count + 1;
            % If accuracy reduces for a number of time, then turn back to the
            % best model and reduce the learning rate
            if acc_drop_count > conf.E_STOP_LR_REDUCE
                fprintf('Learning rate reduced!\n');
                acc_drop_count = 0;
                es_count = es_count + 1; %number of reduce learning rate
                lr = lr/10;
                model = model_best;
            end
        else
            es_count = 0;
            acc_drop_count = 0;
            vld_best = vld_acc;
            tst_best = tst_acc;
            model_best = model;
        end
    end
    % Early stopping
    if isfield(conf,'E_STOP') 
        if isfield(conf,'desire_acc') && vld_acc >= conf.desire_acc, running=0;end
        if es_count > conf.E_STOP, running=0; end
    end

    % Check stop
    if e>=conf.eNum, running=0; end
end
toc;
model = model_best;
vld_acc = vld_best;
tst_acc = tst_best;

%% plotting
if exist('res_e_plot','var')
    
    fig1 = figure(1);
    set(fig1,'Position',[10,20,300,200]);
    plot([1:conf.eNum],res_e_plot);
    xlabel('Epochs');ylabel('Reconstruction Error');
    
    fig2 = figure(2);
    set(fig2,'Position',[210,20,300,200]);
    plot([1:size(trn_acc_plot,2)],trn_acc_plot);
    hold on;
    plot([1:size(vld_acc_plot,2)],vld_acc_plot,'-r');
    legend('Training','Validation','Location','South');
    xlabel('Epochs');ylabel('Accuracy');
end
%res_e_plot = [res_e_plot, res_e];
%        trn_acc_plot = [trn_acc_plot, trn_acc];
%        vld_acc_plot = [vld_acc_plot, vld_acc];
%        sparse_plot = [sparse_plot, hspr];
end
