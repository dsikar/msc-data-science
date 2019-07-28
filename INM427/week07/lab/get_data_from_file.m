function data = get_data_from_file(dat_file)
% Function to read data from a MAT file
%
%   Input
%   -----
%   dat_file : string
%     Path to the MAT file containing data.
%
%   Output
%   ------
%   data : matrix
%     Data loaded from the input MAT file.

    vars = whos('-file', dat_file);
    A = load(dat_file,vars(1).name);
    data = A.(vars(1).name);
end

