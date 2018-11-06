function [ peakBeg,peakEnd ] = seg_var( data,fs )
%使用方差表示信号的能量
    peakBeg = [];
    peakEnd = [];
    % 参数设置
    dataLen=length(data);   % 信号长度
    frameEnergy=[];         % 帧能量
    frameLen=200/1000*fs;   % 帧长
    frameMove=20/1000*fs;   % 帧移
    frameNum=(dataLen-frameLen)/frameMove+1;    % 帧数
    thres=1e5;             % 阈值
    minPeakLen=0.5;           % 可接受的一个峰的最短总长度（帧），如果小于该长度，则将该峰删除
    minInterval=30;          % 可接受的相邻峰最小间隔（帧），如果相邻两峰小于该间隔，则后一个峰被删除
    peakLen=8;             % 一个峰需要的长度（帧）
    delBegLen=40;           % 信号开头需要平滑的峰长度，如不需要平滑信号开头可设为0
    Debug=1;                % 是否画图
    isWarning=1;            % 是否警告
    
    % 获取帧能量
    for i=1:frameNum
        frameBeg=(i-1)*frameMove+1;             % 每帧的开始位置
        frameEnd=frameBeg+frameLen-1;           % 每帧的结束位置
        tmpFrame=data(frameBeg:frameEnd);       % 获取当前帧
        tmpFrame=(tmpFrame-mean(tmpFrame));
        tmpFrame=tmpFrame.*hamming(frameLen)';  % 加窗（汉明窗）
        tmpEnergty=sum(tmpFrame.^2);            % 计算方差
        frameEnergy=[frameEnergy,tmpEnergty];   % 记录帧能量
    end
    
    % 把前面几帧变小，使前面几帧不影响阈值判断
    for i=1:delBegLen
        frameEnergy(i)=frameEnergy(i)*i/delBegLen/2;
    end
    
    % 寻找起始点与结束点
    begFrame=[];
    endFrame=[];
    flag=1;
    for i=1:frameNum
        % 起始点
        if frameEnergy(i)>thres && flag==1
            begFrame=[begFrame,i];
            flag=0;
        end
        % 结束点
        if frameEnergy(i)<=thres && flag==0
            endFrame=[endFrame,i];
            flag=1;
            i = i - 10;
        end
    end
    
    % 删除极短峰
    peakNum=length(endFrame);
    i=1;
    while i<=peakNum
        if endFrame(i)-begFrame(i)<minPeakLen
            if isWarning==1
                disp('发现极短峰！已删除。')
            end
            begFrame(i)=[];
            endFrame(i)=[];
            i=i-1;
            peakNum=peakNum-1;
        end
        i=i+1;
    end
    
    % 合并相邻峰
    peakNum=length(endFrame);
    i=2;
    while i<=peakNum
        if begFrame(i)-endFrame(i-1)<minInterval
            if isWarning==1
                disp('发现相邻峰相隔太近！已删除后一个峰。')
            end
            begFrame(i)=[];
            endFrame(i)=[];
            i=i-1;
            peakNum=peakNum-1;
        end
        i=i+1;
    end
    
    % 异常检测
    if isempty(begFrame)
        disp('没有切割到峰！');
        result=-1;
    else
        % 获取原始数据的起始与结束位置
        endFrame=begFrame+peakLen;      %输出峰取固定长度
        peakBeg=begFrame.*frameMove;    %计算真实起始位置
        peakEnd=endFrame.*frameMove;    %计算真实结束位置
        peakBeg=peakBeg + 20;            %增加缓存区
        peakEnd=peakEnd + 150;           %增加缓存区
        result=1;

        % 出现结束点超过信号长度的情况
        if peakEnd(end)>dataLen
            if peakEnd(end)-dataLen>peakLen*frameMove*0.25
                % 该峰不够完整
                if isWarning==1
                    disp('起始数组与结束数组不一致！已自动删除最后一个起始点');
                end
                peakBeg(end)=[];
                peakEnd(end)=[];
            else
                % 该峰足够完整
                if isWarning==1
                    disp('起始数组与结束数组不一致！已自动取信号尾部为结束点');
                end
                peakEnd(end)=dataLen;      %计算真实结束位置
                peakBeg(end)=peakEnd(end)-(peakEnd(1)-peakBeg(1))+1;    %计算真实起始位置
            end
        end
    end
    
    
    % 画图
    if Debug==1
        % 原图像
        close all;
        h=figure(1);
        set(h,'Position',[10,410,500,350]);
        plot(data);
        hold on;
        for i=1:length(peakBeg)
            plot([peakBeg(i),peakBeg(i)],[min(data),max(data)],'r');
            plot([peakEnd(i),peakEnd(i)],[min(data),max(data)],'r');
        end

        % 帧能量图像
        h=figure(2);
        set(h,'Position',[510,410,500,350]);
        plot(frameEnergy);
        hold on;
        for i=1:length(begFrame)
            plot([begFrame(i),begFrame(i)],[0,max(frameEnergy)],'r');
            plot([endFrame(i),endFrame(i)],[0,max(frameEnergy)],'r');
        end
    end
end