clear;close all;warning off;

load('img_lookuptable.mat');
load('0421-0947.mat');%load net

net.divideParam.valInd = [9 15 23 31 42 62 72 78 91 99];
net.divideParam.testInd = [4 8 13 19 20 25 28 32 36 39 45 46 49 55 61 69 76 85 90 93 100];

result=struct('pos',0,'poserror',[],'sift',0,'sifterror',[],'net',0,'neterror',[]);
result=repmat(result,[size(net.divideParam.testInd,2) 1]);
for i=4:size(net.divideParam.testInd,2)
    [rmse,t]=processimage(img_Lookuptable(net.divideParam.testInd(i)),net.divideParam.testInd(i),net,ps1,ps2,cl);
    time(i)=t;
    result(i).mean=rmse.mean;
    result(i).se_error=rmse.se_error;
end
save result result time;

