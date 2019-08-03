function model = train_ae(conf)
% This code train a AE following Bengio 2006 paper: Greedy Layer-wise Training for Deep nets
% Authors: Son T

% Load data
vars = whos('-file', conf.trn_dat_file);
A = load(conf.trn_dat_file,vars(1).name);
trn_dat = A.(vars(1).name);
clear A;

[sz,visNum] = size(trn_dat);
hidNum      = conf.hidNum;
model.W = 1/(visNum)*(2*rand(visNum,hidNum)-1);
model.visB = zeros(1,visNum);
model.hidB = zeros(1,hidNum);

DW  = zeros(size(model.W));
DVB = zeros(size(model.visB));
DHB = zeros(size(model.hidB));

if conf.bNum == 0
   bNum = sz/conf.sNum;
else
   bNum = conf.bNum;
end

ce_plot = [];
sparse_plot  = [];
for ei=1:conf.eNum
   %tic;
   inx = randperm(sz);
   lr = conf.params(1);
   centropy = 0;
   hspr = 0;
   for b=1:bNum
     visP = trn_dat(inx((b-1)*conf.sNum +1:min(b*conf.sNum,sz)),:);
     sNum = size(visP,1);
     % Upward pass
     hidI = bsxfun(@plus,visP*model.W,model.hidB);
     hidP = logistic(hidI); 
     % Reconstruction
     visNI = bsxfun(@plus,hidP*model.W',model.visB);
     visN = logistic(visNI);
     
     vdiff = (visP-visN);         
     hdiff = (vdiff*model.W).*hidP.*(1-hidP);
     wdiff = visP'*hdiff + vdiff'*hidP;
     
    %pause
      DW = lr*(wdiff/visNum-conf.params(4)*model.W) + conf.params(3)*DW;
      model.W = model.W + DW;

      DVB = lr*mean(vdiff) + conf.params(3)*DVB;
      model.visB = model.visB +DVB;

      DHB = lr*mean(hdiff)/visNum + conf.params(3)*DHB;
      model.hidB  = model.hidB + DHB;

      % Sparsity
      if conf.lambda >0 
            if strcmp(conf.sparsity,'EMIN')
                expectation_min;
            end
           model.W = model.W + lr*w_diff;
           model.hidB = model.hidB + lr*h_diff;
      end
      centropy = centropy + cross_entropy(visP,visN);
      
   end
    %toc;
    fprintf('[Epoch %.4d]: Cross Entropy = %.5f| Sparsity = %.5f\n',ei,centropy,hspr);
    if isfield(conf,'plot')        
        ce_plot = [ce_plot, centropy];        
        sparse_plot = [sparse_plot, hspr];
    end
    %pause
end
if exist('ce_plot','var')    
    fig1 = figure(1);
    set(fig1,'Position',[10,20,300,200]);
    plot(1:size(ce_plot,2),log(ce_plot));
    xlabel('Epochs');ylabel('Cross Entropy');
end
end