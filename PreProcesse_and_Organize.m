clc;clear;close all;

dataPath = './原数据';%保存样本的文件夹路径

% 创建训练集及测试集文件夹
mkdir('./用于神经网络训练的数据/For_Train');
mkdir('./用于神经网络训练的数据/For_Test');

% 创建训练集、测试集及实物 下光谱图像及模糊图像文件夹
mkdir('./用于神经网络训练的数据/For_Train/光谱图像');
mkdir('./用于神经网络训练的数据/For_Test/光谱图像');
mkdir('./用于神经网络训练的数据/For_Train/模糊图像');
mkdir('./用于神经网络训练的数据/For_Test/模糊图像');
mkdir('./用于神经网络训练的数据/实物/光谱图像');
mkdir('./用于神经网络训练的数据/实物/模糊图像');

% 循环处理样本1-57并将其归入训练集
for i=1:57
    %创建样本模糊图像文件夹
    OutputFolder = ['./用于神经网络训练的数据/For_Train/模糊图像/',num2str(i)];
    mkdir(OutputFolder);
    
    %对模糊图像进行几何校正
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'色差模糊图像'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'待校正光谱图像'));
    
    %对模糊图像进行裁剪
    if i==1
        if ~exist('ROI2.mat','file')
            [~,ROI2] = imcrop(Iregistered_cube(:,:,round(FileNum/2)));
            ROI2 = round(ROI2);
            save('ROI2.mat','ROI2');
        else
            load('ROI2.mat','ROI2');
        end
        ROI2(4) = ROI2(4)-1;
        ROI2(3) = ROI2(3)-1;
    end
    Icut_cube = uint16(zeros(ROI2(4)+1,ROI2(3)+1,FileNum));
    for j = 1:FileNum
        Icut_cube(:,:,j) = imcrop(Iregistered_cube(:,:,j),ROI2);
        ImagePath = fullfile(OutputFolder,[num2str(WaveLength(j)),'nm.tif']);
        imwrite(Icut_cube(:,:,j),ImagePath);
    end
    
    %创建样本光谱图像文件夹
    OutputFolder = ['./用于神经网络训练的数据/For_Train/光谱图像/',num2str(i)];
    mkdir(OutputFolder)
    
    %对光谱图像进行几何校正
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'待校正光谱图像'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'待校正光谱图像'));
    
    %对光谱图像进行裁剪
    if i==1
        if ~exist('ROI1.mat','file')
            [~,ROI1] = imcrop(Iregistered_cube(:,:,round(FileNum/2)));
            ROI1 = round(ROI1);
            save('ROI1.mat','ROI1');
        else
            load('ROI1.mat','ROI1');
        end
        ROI1(4) = ROI1(4)-1;
        ROI1(3) = ROI1(3)-1;
    end
    Icut_cube = uint16(zeros(ROI2(4)+1,ROI2(3)+1,FileNum));
    for j = 1:FileNum
        Icut_cube(:,:,j) = imresize(imcrop(Iregistered_cube(:,:,j),ROI1),[ROI2(4)+1 ROI2(3)+1]);
        ImagePath = fullfile(OutputFolder,[num2str(WaveLength(j)),'nm.tif']);
        imwrite(Icut_cube(:,:,j),ImagePath);
    end
end

% 循环处理样本58-63并将其归入测试集
for i=58:63
    %创建样本光谱图像文件夹
    OutputFolder = ['./用于神经网络训练的数据/For_Test/光谱图像/',num2str(i)];
    mkdir(OutputFolder)
    
    %对光谱图像进行几何校正
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'待校正光谱图像'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'待校正光谱图像'));
    
    %对光谱图像进行裁剪
    Icut_cube = uint16(zeros(ROI2(4)+1,ROI2(3)+1,FileNum));
    for j = 1:FileNum
        Icut_cube(:,:,j) = imresize(imcrop(Iregistered_cube(:,:,j),ROI1),[ROI2(4)+1,ROI2(3)+1]);
        ImagePath = fullfile(OutputFolder,[num2str(WaveLength(j)),'nm.tif']);
        imwrite(Icut_cube(:,:,j),ImagePath);
    end
    
    %创建样本模糊图像文件夹
    OutputFolder = ['./用于神经网络训练的数据/For_Test/模糊图像/',num2str(i)];
    mkdir(OutputFolder);
    
    %对模糊图像进行几何校正
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'色差模糊图像'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'待校正光谱图像'));
    
    %对模糊图像进行裁剪
    Icut_cube = uint16(zeros(ROI2(4)+1,ROI2(3)+1,FileNum));
    for j = 1:FileNum
        Icut_cube(:,:,j) = imcrop(Iregistered_cube(:,:,j),ROI2);
        ImagePath = fullfile(OutputFolder,[num2str(WaveLength(j)),'nm.tif']);
        imwrite(Icut_cube(:,:,j),ImagePath);
    end
end
getMAX();
% 将'a.mat'文件复制到'用于神经网络训练的数据'
copyfile('a.mat','用于神经网络训练的数据');

