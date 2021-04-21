% CheckerboardCalibrating.m 脚本基于棋盘格，提取配准点，得到色差模糊高光谱成像系
% 统的几何配准参数该几何配准参数仅适用于目标物固定情况设置下（物距，传输介质），
% 如果目标物设置情况改变，应重新得到几何配准参数。
% 
% 需设置参数：① 棋盘格全幅待几何校正光谱图片的文件夹路径ImageFolder，因为图片需
%               有一定的亮度，所以可以图片可以不必经过透过率校正，否则匹配点识别
%               性能会降低。
%            ② 基准参考波长BaseWavelength，该波段得图片不会经几何变换，其他波
%               段的图片向该波段校准。
% 
% 显示及保存：① 显示校正前后棋盘格与基准波段图像的叠加，配准效果越好，产生的重影
%               越小，选择的ROI为棋盘格区域，目的是为了让展示效果更佳明显，但配
%               准算法是作用于全幅图像的而不是ROI。
%            ② 保存tform.mat文件，tformCalibrating.m 可通过加载该文件对成像系
%               统得到的图片进行几何配准,大小为光谱照片的波段数。

clc;clear;close all;
%% 需设置参数
ImageFolder = '.\原数据\棋盘格\待校正光谱图像'; % 该文件夹需储存固定波段间隔的棋盘格光谱图像
BaseWavelength = 550; %选取参考波长作为基准

%% 检测棋盘格目标
[imageFileNames,FileNum,WaveLength] =getImageFileNames(ImageFolder);
[imagePoints, ~, ~] = detectCheckerboardPoints(imageFileNames);
imagePoints = round(imagePoints);

%% 开始几何校正
fixedPoints = imagePoints(:,:,WaveLength == BaseWavelength);
I = imread(imageFileNames{WaveLength == BaseWavelength});
ROIRectangle = [fixedPoints(end,1),fixedPoints(end,2),...
    fixedPoints(1,1)-fixedPoints(end,1),fixedPoints(1,2)-fixedPoints(end,2)];
h = figure(1);
set(h,'units','normalized','position',[0.1 0.1 0.8 0.8]);

for i = 1:length(imageFileNames)
    J = imread(imageFileNames{i});
    movingPoints = imagePoints(:,:,i);
    tform = fitgeotrans(movingPoints,fixedPoints,'nonreflectivesimilarity');
    tformlist(i) = tform; %#ok<SAGROW>
    Jregistered = imwarp(J,tform,'OutputView',imref2d(size(I)));
    figure(1)
    subplot(1,2,1);
    imshowpair(imcrop(I,ROIRectangle), imcrop(J,ROIRectangle),'blend','Scaling','joint');
    title([num2str(WaveLength(i)) 'nm未配准图像'],'fontsize',15,'Color','r');
    subplot(1,2,2);
    imshowpair(imcrop(I,ROIRectangle), imcrop(Jregistered,ROIRectangle),'blend','Scaling','joint');
    title([num2str(WaveLength(i)) 'nm配准图像'],'fontsize',15);
    pause(0.05);
end

%保存几何变换矩阵，并且保存基准波段
save('tform.mat','tformlist');
save('tform.mat','BaseWavelength','-append');
disp('保存的信息如下:');
whos('-file','tform.mat');