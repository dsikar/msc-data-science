%
function chars = fnGetStudentID(I)
    % Extract student ID from image
    %
    % Parameters: I - image
    %
    % Return character string, if numeral characters found.
    %
    % Example:
    % num = fnGetStudentID(I);
    %
    
    % ================ Start code ================
    % segmentation from lab 5 solution
    % choose colour - approximately white
    J = I(:,:,1)>212 ...
    & I(:,:,2)>215 ...
    & I(:,:,3)>221;   
    % Keep largest component
    K = bwareafilt(logical(J),1);
    % Compute centroid c
    c = regionprops(logical(K), 'Centroid');
    % get polygon around area
    m = 200;
    a = round(c.Centroid(1) - m);
    b = round(c.Centroid(2) - m);
    c = round(a + m * 2);
    d = round(b + m * 2);
    digit = I(b:d, a:c, :);
    % turn to grayscale 
    digit = rgb2gray(digit);
    %imshow(digit);
    % ocr - look for numeric characters only
    ID = ocr(digit,'CharacterSet','.0123456789');
    chars = ID.Text;
    if chars ~= ""
        % if found, remove trailling null character
        chars = deblank(chars);
    end
    % ================ End code ================
end
        