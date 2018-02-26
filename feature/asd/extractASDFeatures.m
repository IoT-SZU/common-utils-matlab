function features=extractASDFeatures(data)
%==================================================
% 提取Skiput相关的features:
% 平均幅度、标准差、绝对�?能量�?56点fft及其中位�?
% data：输入的原始数据
% features：提取的features
% 调整的地方：
% nfft=256;
% fftdata=spectrum((nfft/2+1):(nfft/2+1)+10); %由于频谱的对称�?，只取频谱的右半边作为特�?
%==================================================
data_fft=fft(data); %求fft变换
spectrum=abs(fftshift(data_fft)); %把频谱中心放到终�?
spectrum=spectrum./(max(abs(spectrum))); %对spectrum进行归一�?
nfft=length(spectrum); %获取nfft的点�?
fftdata=spectrum(round(nfft/2)+1:end); %由于频谱的对称�?，只取频谱的右半边作为特�?
features=fftdata;








