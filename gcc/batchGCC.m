function [ gccData ] = batchGCC( base, data, cacheSize )

    gccData = zeros(size(data, 1), size(data, 2) - 2 * cacheSize);
    
    for i=1:size(data, 1)
        gccData(i, :) = GCC(base, data(i:i, :), cacheSize);
    end

end

