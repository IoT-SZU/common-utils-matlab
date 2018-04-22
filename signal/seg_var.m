function [ peakBeg, peakEnd ] = seg_var( data, fs )
% 切段前请先滤掉直流分量

    peakBeg = [];
    peakEnd = [];

    % Config
    len = length(data);     % 信号总长度
    signalLen = 0.4 * fs;   % 单个信号长度
    DEBUG = true;           % 是否画图
    THRESHOLD = 0.006;
    MIN_LEN = floor(signalLen * 0.3);

    % 将信号数据转换为比较好识别信号的一个数组
    % 设某一帧的数据为 data
    % 则每一帧的值计算方法为 x = abs(mean(diff(data))) / max(data);
    absData = abs(data);
    values = zeros(1, len);
    lessCount = 0;
    highlightX = [];
    highlightY = [];
    lastDiffValue = sum(diff(absData(1:signalLen)));
    for i=signalLen + 1 : len - signalLen
        frameData = absData(i - signalLen:i);
        currentDiffValue = lastDiffValue - (absData(i - signalLen + 1) - absData(i - signalLen)) + (absData(i) - absData(i - 1));
        values(i) = abs(currentDiffValue / signalLen) / max(frameData);
        lastDiffValue = currentDiffValue;
        if values(i) < THRESHOLD
            lessCount = lessCount + 1;
        else
            m = i - lessCount;
            b = m - signalLen;
            e = m + signalLen;
            if lessCount >= MIN_LEN && sum(data(b:m) .^ 2) / sum(data(m:e) .^ 2) > 2
                highlightX = [highlightX, m:i];
                highlightY = [highlightY, data(m:i)];
                peakBeg = [peakBeg, b];
                peakEnd = [peakEnd, e];
            end
            lessCount = 0;
        end
    end

    % 判断最后一个是否是一个信号
    m = i - lessCount;
    b = m - signalLen;
    e = m + signalLen;
    if lessCount >= MIN_LEN && sum(data(b:m) .^ 2) / sum(data(m:e) .^ 2) > 2
        highlightX = [highlightX, m:i];
        highlightY = [highlightY, data(m:i)];
        peakBeg = [peakBeg, b];
        peakEnd = [peakEnd, e];
    end

    % 画图
    if DEBUG
        close all;
        figure;
        subplot(2, 1, 1);
        hold on;
        % 原图像
        plot(data);
        % 高亮小于阈值的点
        for i=1:length(highlightX)
            plot(highlightX(i), highlightY(i), '.r');
        end
        % 切割位置
        for i=1:length(peakBeg)
            plot([peakBeg(i), peakBeg(i)],[min(data),max(data)],'b');
            plot([peakEnd(i), peakEnd(i)],[min(data),max(data)],'r');
        end

        subplot(2, 1, 2);
        hold on;
        plot(values);
        plot([1, len], [THRESHOLD, THRESHOLD], 'r');
    end
end

