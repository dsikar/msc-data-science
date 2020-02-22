    % create an empty 3 rows x 11 columns matrix to hold our posterior variance
    % values and calculations
    post_vals = zeros(3, 11);
    % our prior and current variances as per example code
    ps2 = 4; ls2 = 3;
    % store the first prior variance
    post_vals(1, 1) = ps2;
    for i = 1:10, 
        Ps2 = (1/ps2 + 1/ls2)^(-1);
        % save the new posterior variance
        post_vals(1, i+1) = Ps2;
        % save the change ratio new posterior variance/old posterior variance
        post_vals(2, i+1) = Ps2/ps2; 
        % save the difference old posterior variance - new posterior variance
        post_vals(3, i+1) = ps2 - Ps2;      
        % change prior variance
        ps2 = Ps2;
    %end;
    % Display the information
    disp(post_vals)