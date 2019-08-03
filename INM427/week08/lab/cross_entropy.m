function cr_en = cross_entropy(x,y)
 cr_en = mean(sum(-x.*log(y) -(1-x).*log(1-y),2));
end
