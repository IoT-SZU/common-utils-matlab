function [gfcc,g]=GFCC(data,sampFreq, numChannel)
gt = gen_gammaton(sampFreq, numChannel);  % get gammatone filterbank
g=fgammaton(data, gt, sampFreq, numChannel);     % gammatone filter pass and decimation to get GF features
gfcc = gtf2gtfcc(g, 1, 32);  % apply dct to get GFCC features with 0th coefficient removed
end