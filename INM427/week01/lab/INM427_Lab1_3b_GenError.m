% Generalisation error solution attempt for exercise 3b as per
% https://moodle.city.ac.uk/pluginfile.php/1582800/mod_resource/content/1/tutorial1.pdf

% clear plot 
clf
% x axis array values within unit square
x = linspace(0,1,1000);
% line equations as per exercise 3a
% 1. (3a) with intercepts (0,0.5) (0.75,0) i.e. (-0.5,2/3,1)
y1 = -2/3 * x + 1/2;
% 2. (3b) as per weights produced by perceptron network (-0.2,0.51,0.03)
y2 = (-0.51*x + 0.2)/0.03;
% set visible plot x y limits to unit square
xlim([0,1]);
ylim([0,1]);
% find the line intersect
idx = findLineIntersect(x, y1, y2);
xint = x(idx);
y1int = y1(idx);
y2int = y2(idx); % not needed, should be fairly close to y1int

% keep the plot on as we overlay
hold on
plot(x,y1,'b--')
plot(x,y2,'g--')

% Add graph info
title("Generalisation error")
xlabel("X")
ylabel("Y")
legend('y1 = -2/3 * x + 1/2', 'y2 = (-0.51*x + 0.2)/0.03')
text(0.16,0.7,'FN','FontSize',18)
text(0.43,0.1,'FP','FontSize',18)

% find False Negative polygon edges
FN_polx1 = xint; % intercept
FN_poly1 = y1int;
FN_polx2 = 0;    % bottom left edge 
FN_poly2 = y1(1);  
FN_polx3 = 0;    % top left edge
FN_poly3 = 1;
% Find index for array x when y2 = 1
xidx = findClosestValueIndex(x, y2, 1)
FN_polx4 = x(xidx); % top right edge
FN_poly4 = 1;

% find False Positive polygon edges NB only 3 edges
FP_polx1 = xint; % intercept
FP_poly1 = y1int;
% Find index for array x when y2 = 0
xidx = findClosestValueIndex(x, y2, 0)
FP_polx2 = x(xidx); % bottom left edge
FP_poly2 = 0;    
% Find index for array x when y1 = 0
xidx = findClosestValueIndex(x, y1, 0)
FP_polx3 = x(xidx); % bottom right edge
FP_poly3 = 0;

% false positive polygon x y arrays
FP_X = [FP_polx1 FP_polx2 FP_polx3]; 
FP_Y = [FP_poly1 FP_poly2 FP_poly3];  

% false negative polygon x y arrays
FN_X = [FN_polx1 FN_polx2 FN_polx3 FN_polx4];
FN_Y = [FN_poly1 FN_poly2 FN_poly3 FN_poly4];
    
% generalisation error i.e. sum of polygon areas
gen_error = polyarea(FN_X,FN_Y) + polyarea(FP_X,FP_Y);
gen_error_str = sprintf('Area (error): %.03f (%.01f%%)',gen_error, gen_error*100);
text(0.4,0.5, gen_error_str,'FontSize',16)

% debug line intersects
%plot the two line intersect
%plot(xint,y1int,'ro')

% plot FN and FP polygon edges
%plot(FP_polx1, FP_poly1, 'ro')
%plot(FP_polx2, FP_poly2, 'ro')
%plot(FP_polx3, FP_poly3, 'ro')
%plot(FN_polx1, FN_poly1, 'ro')
%plot(FN_polx2, FN_poly2, 'ro')
%plot(FN_polx3, FN_poly3, 'ro')
%plot(FN_polx4, FN_poly4, 'ro')

% debug polygons i.e. make sure they are where we expect them to be
%fill(FP_X,FP_Y,'g')
%fill(FN_X,FN_Y,'r')



%%%%%%%%%%%%%%%%%%%%%%%%
% HELPER FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%

% Find line x index of line intersect - brute force approach
% TODO implement with matrix of line equations
function idx = findLineIntersect(x, y1, y2)
    % start with a large value
    iMin = sum(abs(y1));
    for k = 1:numel(x)
        % take absolute difference of y values
        iMinTemp = abs(y1(k) - y2(k))
        if iMinTemp < iMin
            % these two points are closer, save them
            iMin = iMinTemp;
            % save the index, as this is our x value
            idx = k;
        end
    end
end

% find index closest to a given value - brute force approach
% TODO implement with matrix of line equations
function idx = findClosestValueIndex(x, y1, val)
    % start with a large value
    iMin = sum(abs(y1));
    for k = 1:numel(x)
        % take absolute difference of y values
        iMinTemp = abs(y1(k) - val)
        if iMinTemp < iMin
            % these two points are closer, save them
            iMin = iMinTemp;
            % save the index, as this is our x value
            idx = k;
        end
    end
end
