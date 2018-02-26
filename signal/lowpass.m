%----------------------------------
% 函数用于低通滤波处理
% data:输入信号
% fs:data的采样频率
% f:低通滤波的截止频率
% dataOut:滤波后的信号
% ---------------------------------
function [dataOut]=lowpass(data,fs,f)
%低通滤波：滤除 f HZ以上的信号
[b,a] = butter(8,f/fs*2);
dataOut = filter(b,a,data);