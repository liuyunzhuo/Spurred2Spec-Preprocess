function [imageFileNames,FileNum,WaveLength] = getImageFileNames(ImageFolder)
% readImageCube ������������ͼƬ������Ԫ������,��ͼƬ����,������ͼƬ�Ĳ������顣
    WaveLength = []; %�ɼ��Ĺ���ͼƬ�Ĳ���
    File = dir(fullfile(ImageFolder ,'*.tif')); %��ʾ�ļ��������з��Ϻ�׺��Ϊ.tif�ļ���������Ϣ
    FileNum = length(File);
    disp(['"' ImageFolder '"' ' �ļ����¹���' num2str(FileNum) '����Ƭ']);
    for i = 1:FileNum
       str = File(i).name;
       WaveLength(i) = str2double(str(1:3));  
       imageFileName = File(i).name;
       imageFileNames{i} = fullfile(ImageFolder, imageFileName); 
    end
    disp(['���ײ�����Ϣ: ' num2str(WaveLength(1)) 'nm �� '...
        num2str(WaveLength(end)) 'nm,���μ��'...
        num2str(WaveLength(end)-WaveLength(end-1)) 'nm']);
end