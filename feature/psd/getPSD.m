function [ output ] = getPSD( input,fs )
%UNTITLED input为信号，len为信号长�?fs为采样频�?
%   此处显示详细说明
len = size(input, 2);
ff = fft(input',len)';
ff = abs(ff(:, 1:floor(len / 2) + 1));
X=ff.*ff./(fs*len);
Y=10*log10(X);
output=Y;

end

