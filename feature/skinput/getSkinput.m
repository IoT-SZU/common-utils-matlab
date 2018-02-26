function [ skinputData ] = getSkinput( data )

    skinputData = [];
    
    for i=1:size(data, 1)
        skinputData = [skinputData; extractSkinputFeatures(data(i, :))];
    end
end

