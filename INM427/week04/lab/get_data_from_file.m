function data = get_data_from_file(dat_file)
    vars = whos('-file', dat_file);
    A = load(dat_file,vars(1).name);
    data = A.(vars(1).name);
end

