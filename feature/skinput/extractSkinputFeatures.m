function features=extractSkinputFeatures(data)
%==================================================
% 提取Skiput相关的features:
% 平均幅度、标准差、绝对�?能量�?56点fft及其中位�?
% data：输入的原始数据
% features：提取的features
% 调整的地方：
% nfft=256;
% fftdata=spectrum((nfft/2+1):(nfft/2+1)+10); %由于频谱的对称�?，只取频谱的右半边作为特�?
%==================================================
nfft=256;
data=data./max(abs(data)); %对数据进行归�?��
aveAmplitude=mean(data); %求平均幅�?
standardDev=std(data,1); %求标准差
abEnergy=sum(abs(data)); %求绝对�?能量
data_fft=fft(data,nfft); %求fft变换
spectrum=abs(fftshift(data_fft)); %把频谱中心放到终�?
spectrum=spectrum./(max(abs(spectrum))); %对spectrum进行归一�?
fftdata=spectrum((nfft/2+1):end); %由于频谱的对称�?，只取频谱的右半边作为特�?
powerSpectrum=fftdata.^2; %求功率谱
% 求中位数
if mod(length(powerSpectrum),2)==0
    centerPowerSpectrum=sum(powerSpectrum(length(powerSpectrum)/2:length(powerSpectrum)/2+1))/2;  %取功率谱的中心作为特�?
else
    centerPowerSpectrum=powerSpectrum((length(powerSpectrum)+1)/2);  %取功率谱的中心作为特�?
end
%集合左右的特�?
features=[aveAmplitude,standardDev,abEnergy,fftdata,centerPowerSpectrum];
% features=fftdata;








