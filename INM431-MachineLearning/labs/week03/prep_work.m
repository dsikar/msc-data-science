    % clear workspace
    clear; clc;
    % create an empty 6 rows x 11 columns matrix to hold our posterior variance
    % and mean changewith every iteration
    % values and calculations
    post_vals = zeros(6, 11);
    % our prior and current variances as per example code
    ps2 = 4; ls2 = 3;
    % our prior mean
    pm = 5;
    lm = 6; % sample mean
    ls2 = 3; % sample variance,     
    % store the first prior variance
    post_vals(1, 1) = ps2;
    % code starting to fill up with magic numbers, not good practice
    post_vals(4, 1) = pm;
    for i = 1:10, 
        Ps2 = (1/ps2 + 1/ls2)^(-1);
        % save the new posterior variance
        post_vals(1, i+1) = Ps2;
        % save the change ratio new posterior variance/old posterior variance
        post_vals(2, i+1) = Ps2/ps2; 
        % save the difference new posterior variance - old posterior variance
        post_vals(3, i+1) = Ps2 - ps2; 
        % same for mean
        Pm = Ps2*(pm/ps2 + lm/ls2);
        % save the new mean value
        post_vals(4, i+1) = Pm;
        % save the change ratio new mean/old mean
        post_vals(5, i+1) = Pm/pm;
        % save the difference new mean - old mean
        post_vals(6, i+1) = Pm - pm;         
        % change prior variance
        ps2 = Ps2;
        % change mean
        pm = Pm;
    end;
    % Display the information
    disp(post_vals)
  % We started with prior variance ps2 = 4 and mean pm = 5. Our sample
  % variance and mean remain fixed at ls2 = 3 and lm = 6
  % With every iteration, posterior variance is decreasing, while the mean
  % is increasing, getting closer to the sample mean lm = 6
  % The normal distribution bell shape is getting narrower and taller, so
  % we have a higher likelihood of observations near mean?
  % Do we not want our variance to also approach the sample variance?
  
  %  4.0000    1.7143    1.0909    0.8000    0.6316    0.5217    0.4444    0.3871    0.3429    0.3077    0.2791
  %       0    0.4286    0.6364    0.7333    0.7895    0.8261    0.8519    0.8710    0.8857    0.8974    0.9070
 %        0   -2.2857   -0.6234   -0.2909   -0.1684   -0.1098   -0.0773   -0.0573   -0.0442   -0.0352   -0.0286
 %   5.0000    5.5714    5.7273    5.8000    5.8421    5.8696    5.8889    5.9032    5.9143    5.9231    5.9302
  %       0    1.1143    1.0280    1.0127    1.0073    1.0047    1.0033    1.0024    1.0019    1.0015    1.0012
  %       0    0.5714    0.1558    0.0727    0.0421    0.0275    0.0193    0.0143    0.0111    0.0088    0.0072   
  
  