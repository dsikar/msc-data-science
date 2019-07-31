function data2arff(data, arff_name)
% row - instances
% column - features
% column(end) - label

    [nrow,ncol] = size(data);
    class = unique(data(:,end));
    n_class = length(class);

    arf = '.arff';
    filename = [arff_name,arf];
    FID = fopen(filename,'w');

    arff_head = arff_name;

    fprintf(FID,'@relation %s \n\n',arff_head);

    for i = 1:ncol-1
        fprintf(FID,'@attribute feature_%d numeric\n',i);
    end

    % class line
    class_id = [];
    for k = 1:n_class-1
        class_id = [class_id sprintf('%d,',class(k))];
    end
    class_id = [class_id num2str(class(end))];

    fprintf(FID,'@attribute class {%s} \n@data \n',class_id);

    % data block
    for nr = 1:nrow
        for nc = 1:ncol-1
            data_block{nr,nc} = [sprintf('%d,',data(nr,nc))];
            data_block{nr,nc+1} = [sprintf('%d',data(nr,ncol))];
        end
    end

    % write data block
    for nr = 1:nrow
        for nc = 1:ncol
            fprintf(FID,'%s',data_block{nr,nc});
        end
        fprintf(FID,'\n');
    end

    fclose(FID);
end 