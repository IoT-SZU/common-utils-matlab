function [MfccOut]=mfcc_transform( data, fs, Tw, Ts, alpha, M, C, LF, HF)
% Define variables
% Tw = 25;                % analysis frame duration (ms)   帧持续时长
% Ts = 10;                % analysis frame shift (ms)    帧移
% alpha = 0.97;           % preemphasis coefficient   预加重
% M = 20;                 % number of filterbank channels  滤波器通道数
% C = 13;                 % number of cepstral coefficients  倒谱系数
L = 22;                 % cepstral sine lifter parameter   倒谱正弦参数
% LF = 10;               % lower frequency limit (Hz)   低频门限
% HF = 800;              % upper frequency limit (Hz)  高频门限

MfccOut = [];
for i = 1:size(data, 1)
    OriginalData = data(i, :);
    FlattenedData = OriginalData(:)'; % 展开矩阵为一列，然后转置为一行。
    MappedFlattened = mapminmax(FlattenedData); % 归一化。
    MappedData = reshape(MappedFlattened, size(OriginalData)); % 还原为原始矩阵形式。
    % 归一化后的数据
    speech = MappedData;
    
    [ MFCCs, FBEs, frames ] =mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L );
    Mfcc=[];
    
    for i=1:size(MFCCs,1)
        Mfcc=[Mfcc,MFCCs(i,:)];
    end
    MfccOut=[MfccOut; Mfcc];
end

end
