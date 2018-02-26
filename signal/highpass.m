%----------------------------------
% 函数用于高通滤波处理
% data:输入信号
% fs:data的采样频率
% f:高通滤波的截止频率
% dataOut:滤波后的信号
% ---------------------------------
function [dataOut]=highpass(data,fs,f)
%高通滤波：滤除 f HZ以下的信号
[b,a] = butter(2,f/fs*2,'high');
dataOut = filter(b,a,data);