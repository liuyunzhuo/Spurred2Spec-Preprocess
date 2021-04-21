clc;clear;close all;
ImageFolder = './原数据/1/待校正光谱图像';
[imageFileNames,FileNum,WaveLength] = getImageFileNames(ImageFolder);
load tform.mat tformlist;
load tform.mat BaseWavelength;
load a.mat
I = imread(imageFileNames{WaveLength == BaseWavelength});
shape = size(I);
R = double(zeros(shape));
G = double(zeros(shape));
B = double(zeros(shape));
for i = 1:FileNum
    J = imread(imageFileNames{i});
    [pathstr,name,ext]=fileparts(imageFileNames{i});
    tform = tformlist(i); 
    Jregistered = imwarp(J,tform,'OutputView',imref2d(size(I)));
    Jrectify = im2double(Jregistered)*a(i);
    [r,g,b]=spec2RGB(WaveLength(i));
    R = R + r*Jrectify;
    G = G + g*Jrectify;
    B = B + b*Jrectify;
end
R = (R./FileNum);
G = (G./FileNum);
B = (B./FileNum);

R(R>1) = 1;
G(G>1) = 1;
B(B>1) = 1;
img = cat(3,R,G,B);
figure;
imshow(img);