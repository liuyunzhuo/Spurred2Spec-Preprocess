% CheckerboardCalibrating.m �ű��������̸���ȡ��׼�㣬�õ�ɫ��ģ���߹��׳���ϵ
% ͳ�ļ�����׼�����ü�����׼������������Ŀ����̶���������£���࣬������ʣ���
% ���Ŀ������������ı䣬Ӧ���µõ�������׼������
% 
% �����ò������� ���̸�ȫ��������У������ͼƬ���ļ���·��ImageFolder����ΪͼƬ��
%               ��һ�������ȣ����Կ���ͼƬ���Բ��ؾ���͸����У��������ƥ���ʶ��
%               ���ܻή�͡�
%            �� ��׼�ο�����BaseWavelength���ò��ε�ͼƬ���ᾭ���α任��������
%               �ε�ͼƬ��ò���У׼��
% 
% ��ʾ�����棺�� ��ʾУ��ǰ�����̸����׼����ͼ��ĵ��ӣ���׼Ч��Խ�ã���������Ӱ
%               ԽС��ѡ���ROIΪ���̸�����Ŀ����Ϊ����չʾЧ���������ԣ�����
%               ׼�㷨��������ȫ��ͼ��Ķ�����ROI��
%            �� ����tform.mat�ļ���tformCalibrating.m ��ͨ�����ظ��ļ��Գ���ϵ
%               ͳ�õ���ͼƬ���м�����׼,��СΪ������Ƭ�Ĳ�������

clc;clear;close all;
%% �����ò���
ImageFolder = '.\ԭ����\���̸�\��У������ͼ��'; % ���ļ����财��̶����μ�������̸����ͼ��
BaseWavelength = 550; %ѡȡ�ο�������Ϊ��׼

%% ������̸�Ŀ��
[imageFileNames,FileNum,WaveLength] =getImageFileNames(ImageFolder);
[imagePoints, ~, ~] = detectCheckerboardPoints(imageFileNames);
imagePoints = round(imagePoints);

%% ��ʼ����У��
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
    title([num2str(WaveLength(i)) 'nmδ��׼ͼ��'],'fontsize',15,'Color','r');
    subplot(1,2,2);
    imshowpair(imcrop(I,ROIRectangle), imcrop(Jregistered,ROIRectangle),'blend','Scaling','joint');
    title([num2str(WaveLength(i)) 'nm��׼ͼ��'],'fontsize',15);
    pause(0.05);
end

%���漸�α任���󣬲��ұ����׼����
save('tform.mat','tformlist');
save('tform.mat','BaseWavelength','-append');
disp('�������Ϣ����:');
whos('-file','tform.mat');