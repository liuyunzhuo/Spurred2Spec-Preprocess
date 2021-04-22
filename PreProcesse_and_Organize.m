clc;clear;close all;

dataPath = './ԭ����';%�����������ļ���·��

% ����ѵ���������Լ��ļ���
mkdir('./����������ѵ��������/For_Train');
mkdir('./����������ѵ��������/For_Test');

% ����ѵ���������Լ���ʵ�� �¹���ͼ��ģ��ͼ���ļ���
mkdir('./����������ѵ��������/For_Train/����ͼ��');
mkdir('./����������ѵ��������/For_Test/����ͼ��');
mkdir('./����������ѵ��������/For_Train/ģ��ͼ��');
mkdir('./����������ѵ��������/For_Test/ģ��ͼ��');
mkdir('./����������ѵ��������/ʵ��/����ͼ��');
mkdir('./����������ѵ��������/ʵ��/ģ��ͼ��');

% ѭ����������1-57���������ѵ����
for i=1:57
    %��������ģ��ͼ���ļ���
    OutputFolder = ['./����������ѵ��������/For_Train/ģ��ͼ��/',num2str(i)];
    mkdir(OutputFolder);
    
    %��ģ��ͼ����м���У��
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'ɫ��ģ��ͼ��'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'��У������ͼ��'));
    
    %��ģ��ͼ����вü�
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
    
    %������������ͼ���ļ���
    OutputFolder = ['./����������ѵ��������/For_Train/����ͼ��/',num2str(i)];
    mkdir(OutputFolder)
    
    %�Թ���ͼ����м���У��
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'��У������ͼ��'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'��У������ͼ��'));
    
    %�Թ���ͼ����вü�
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

% ѭ����������58-63�����������Լ�
for i=58:63
    %������������ͼ���ļ���
    OutputFolder = ['./����������ѵ��������/For_Test/����ͼ��/',num2str(i)];
    mkdir(OutputFolder)
    
    %�Թ���ͼ����м���У��
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'��У������ͼ��'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'��У������ͼ��'));
    
    %�Թ���ͼ����вü�
    Icut_cube = uint16(zeros(ROI2(4)+1,ROI2(3)+1,FileNum));
    for j = 1:FileNum
        Icut_cube(:,:,j) = imresize(imcrop(Iregistered_cube(:,:,j),ROI1),[ROI2(4)+1,ROI2(3)+1]);
        ImagePath = fullfile(OutputFolder,[num2str(WaveLength(j)),'nm.tif']);
        imwrite(Icut_cube(:,:,j),ImagePath);
    end
    
    %��������ģ��ͼ���ļ���
    OutputFolder = ['./����������ѵ��������/For_Test/ģ��ͼ��/',num2str(i)];
    mkdir(OutputFolder);
    
    %��ģ��ͼ����м���У��
    Iregistered_cube = tformCalibratingnoshow(fullfile(dataPath,num2str(i),'ɫ��ģ��ͼ��'));
    [~,FileNum,WaveLength] = getImageFileNames(fullfile(dataPath,num2str(i),'��У������ͼ��'));
    
    %��ģ��ͼ����вü�
    Icut_cube = uint16(zeros(ROI2(4)+1,ROI2(3)+1,FileNum));
    for j = 1:FileNum
        Icut_cube(:,:,j) = imcrop(Iregistered_cube(:,:,j),ROI2);
        ImagePath = fullfile(OutputFolder,[num2str(WaveLength(j)),'nm.tif']);
        imwrite(Icut_cube(:,:,j),ImagePath);
    end
end
getMAX();
% ��'a.mat'�ļ����Ƶ�'����������ѵ��������'
copyfile('a.mat','����������ѵ��������');

