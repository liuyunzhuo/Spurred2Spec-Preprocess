function [img, BaseWavelength]= LCTF2RGB(ImageFolder)
    % LCTF2RGB.m 函数基于tfom.mat 与 a.mat，合成RGB图像，这两个参数需分别运行
    % CheckerboardCalibrating.m 与 rectify.m
    % 
    % 需设置参数：① 棋盘格全幅待几何与透过率校正光谱图片的文件夹路径ImageFolder
    % 
    % 返回：① 返回向基准波长校准的RGB的图片img
    %       ② 基准波长 BaseWavelength
    [imageFileNames,FileNum,WaveLength] = getImageFileNames(ImageFolder);
    load tform.mat tformlist;
    load tform.mat BaseWavelength;
    load a.mat a;
    I = imread(imageFileNames{WaveLength == BaseWavelength});
    shape = size(I);
    R = double(zeros(shape));
    G = double(zeros(shape));
    B = double(zeros(shape));
    for i = 1:FileNum
        J = imread(imageFileNames{i});
%         [pathstr,name,ext]=fileparts(imageFileNames{i});
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
end