function features = extractMFCCFeatures(data, fs, Tw, Ts, alpha, R, M, N, L)
%==================================================
% 提取MFCC相关的features:
% data：输入的原始数据
% features：提取的features
%==================================================
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

features = [];

for i=1:size(data, 1)
    [ MFCCs, ~, ~ ] = mfcc(data(i, :), fs, Tw, Ts, alpha, hamming, R, M, N, L);
    features = [features; reshape(MFCCs, 1, [])];
end
