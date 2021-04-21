% rectify.m �ű�����Բ��Ŀ����/��У������ͼ�񣨼���У����������ǲ�õĹ�����
% ���Ƚϣ��õ������ε�͸����У����������͸��������������������Ŀ����̶��������
% �£���࣬������ʣ������Ŀ������������ı䣬Ӧ���µõ�͸��������������
% 
% �����ò������� ��������У�����Բ��Ŀ�����͸����У���Ĺ���ͼƬ�ļ���·��
%               ImageInputFolder
%            �� ��׼�ο�����BaseWavelength���ò��ε�ͼƬ���ᾭ���α任��������
%               �ε�ͼƬ��ò���У׼��
% 
% ���棺�� �õ�͸����У��ϵ��a.mat

clear;close all;clc;

%% �����ò���
ImageInputFolder = './ԭ����/Բ��Ŀ����/��У������ͼ��';
ModelInputFolder = './ԭ����/��ɫԲ�����.csv';

%% ��Բ��Ŀ������м���У��
tformCalibrating(ImageInputFolder,[0,0,1920,1080]);
close;
ImageInputFolder = [ImageInputFolder '(����У����)'];
%% ���͸����У������a.mat
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

%����͸����У��ϵ��
save('a.mat','a');
disp('�������Ϣ����:');
whos('-file','a.mat');