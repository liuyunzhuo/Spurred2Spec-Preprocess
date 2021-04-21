% rectify.m 脚本基于圆盘目标物/待校正光谱图像（几何校正后）与光谱仪测得的光谱曲
% 作比较，得到各波段的透过率校正参数，该透过率修正参数仅适用于目标物固定情况设置
% 下（物距，传输介质），如果目标物设置情况改变，应重新得到透过率修正参数。
% 
% 需设置参数：① 经过几何校正后的圆盘目标物待透过率校正的光谱图片文件夹路径
%               ImageInputFolder
%            ② 基准参考波长BaseWavelength，该波段得图片不会经几何变换，其他波
%               段的图片向该波段校准。
% 
% 保存：① 得到透过率校正系数a.mat

clear;close all;clc;

%% 需设置参数
ImageInputFolder = './原数据/圆点目标物/待校正光谱图像';
ModelInputFolder = './原数据/白色圆点光谱.csv';

%% 对圆点目标物进行几何校正
tformCalibrating(ImageInputFolder,[0,0,1920,1080]);
close;
ImageInputFolder = [ImageInputFolder '(几何校正后)'];
%% 获得透过零校正参数a.mat
% path = readpic(ImageInputFolder);
[imageFileNames,FileNum,WaveLength] =getImageFileNames(ImageInputFolder);
shape = size(imread(imageFileNames{1}));
[~,ROI] = imcrop(imread(imageFileNames{1}));
close;
ROI = round(ROI);

% mid = shape./2;
% p1 = [mid(1) + delt , mid(2)];
% p2 = [mid(1) , mid(2) + delt];
% p3 = [mid(1) - delt , mid(2)];
% p4 = [mid(1) , mid(2) - delt];

model = csvread(ModelInputFolder,53);
model(:,3) = [];
data = zeros(FileNum,2);
data(:,1) = WaveLength;
for i = 1:FileNum
    p = imread(imageFileNames{i});
    p = int32(p);
    mea = mean(p(ROI(2):ROI(2)+ROI(4),ROI(1):ROI(1)+ROI(3)),'all');
    data(i,2)= mea ;
end
obj(:,1) = data(:,1);
obj(:,2) = data(:,2)./65535;
n = size(model);
for i = 1:n(1)
    if model(i,1)>=WaveLength(1) && model(i,1)<=WaveLength(end)
        if mod(model(i,1),2)~=0
            model(i,:) = 0;
        end
    else
        model(i,:) = 0;
    end
end
index = model(:,1)==0;
model(index,:) = [];
a = model(:,2)./obj(:,2);

%保存透过率校正系数
save('a.mat','a');
disp('保存的信息如下:');
whos('-file','a.mat');