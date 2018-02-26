function [ data, offset ] = GCC( data1, data2, cacheSize )
    len = size(data1,2);

    m = sum(data1 .* data2);
    offset = 1;
    for i=1:len
        % aaaaa000
        % 000bbbbb
        tmp = sum(data1(i:end) .* data2(1:len - i + 1));
        if tmp > m
            m = tmp;
            offset = i;
        end
        % 000aaaaa
        % bbbbb000
        tmp = sum(data2(i:end) .* data1(1:len - i + 1));
        if tmp > m
            m = tmp;
            offset = -i;
        end
    end
    data = data2;
    if offset < 0
        offset = offset;
        data(1:end + offset + 1) = data2(-offset:end);
    else
        offset = offset;
        data(offset:end) = data2(1:end - offset + 1);
    end
    
    data = data(:, cacheSize + 1 : end - cacheSize);
end

