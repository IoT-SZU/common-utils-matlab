function [ asdData ] = getASD( data )
    asdData = [];

    for i=1:size(data, 1)
        asdData = [asdData; extractASDFeatures(data(i, :))];
    end
end

