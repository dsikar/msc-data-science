function cout = run_nn(actFncs,model,dat)
    for i=1:length(actFncs)
        input = bsxfun(@plus,dat*model.Ws{i},model.bs{i});
        actFunc=  str2func(actFncs{i});
        dat = actFunc(input);
    end      
    [~,cout] = max(dat,[],2);
end

