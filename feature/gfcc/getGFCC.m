function [ GFCCData ] = getGFCC( data,sampFreq,numChannel )

dataRow=size(data,1);
GFCCData=[];
for j=1:dataRow
	[gfcc,g]=GFCC(data(j,:),sampFreq, numChannel);
    gfcc=gfcc(:);
    g=g(:);
    temp=[gfcc',g'];
	GFCCData=[GFCCData;temp];
end

end

