function d = deriv(func_name,input)
    func = str2func(func_name);
    output = func(input);
    if strcmp(func_name,'logsig')        
        d = output.*(1-output);
    elseif strcmp(func_name,'tansig')
        d = 1-output.^2;
    elseif strcmp(func_name,'purelin')
        d= 1;
    end
end