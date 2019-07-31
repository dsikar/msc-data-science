function output = rbm_classify(model,tst_dat,opt)
% RBM classification

switch opt
    case 1
        output = gen_rbm_classify(model,tst_dat);
    case 2
        output = dis_rbm_classify(model,tst_dat);
end


end

