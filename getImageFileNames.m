function [imageFileNames,FileNum,WaveLength] = getImageFileNames(ImageFolder)
% readImageCube 函数返回所有图片的名字元胞数组,及图片数量,及所有图片的波段数组。
    WaveLength = []; %采集的光谱图片的波长
    File = dir(fullfile(ImageFolder ,'*.tif')); %显示文件夹下所有符合后缀名为.tif文件的完整信息
    FileNum = length(File);
    disp(['"' ImageFolder '"' ' 文件夹下共有' num2str(FileNum) '张照片']);
    for i = 1:FileNum
       str = File(i).name;
       WaveLength(i) = str2double(str(1:3));  
       imageFileName = File(i).name;
       imageFileNames{i} = fullfile(ImageFolder, imageFileName); 
    end
    disp(['光谱波段信息: ' num2str(WaveLength(1)) 'nm 至 '...
        num2str(WaveLength(end)) 'nm,波段间隔'...
        num2str(WaveLength(end)-WaveLength(end-1)) 'nm']);
end