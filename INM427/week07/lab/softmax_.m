function L = softmax_(inp)
% Softmax function
% inp : input to softmax unit~log (exp(inp)) (not exp)
% sontran2014
inp_o = inp;
[m,n] = size(inp);
inp = exp(bsxfun(@minus,inp,max(inp,[],2)));
prob = bsxfun(@rdivide,inp,sum(inp,2));
p = cumsum(prob,2)>repmat(rand(m,1),1,n);
L = n + 1 - sum(p,2);
end
