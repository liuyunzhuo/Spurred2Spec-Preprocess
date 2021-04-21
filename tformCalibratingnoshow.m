function Jregistered_cube = tformCalibratingnoshow(ImageFolder)
% tformCalibrating 函数输入图片储存的文件夹,创建一个文件夹后输出所有几何校正后的图片(全幅)。
    [pathstr,name]=fileparts(ImageFolder);
    mkdir(pathstr,[name,'(几何校正后)']);
    [imageFileNames,FileNum,WaveLength] = getImageFileNames(ImageFolder);
    
    load tform.mat tformlist;
    load tform.mat BaseWavelength;
    I = imread(imageFileNames{WaveLength == BaseWavelength});
    [rows,cols] = size(I);
    Jregistered_cube = uint16(zeros(rows,cols,FileNum));
    for i = 1:length(imageFileNames)
        J = imread(imageFileNames{i});
        tform = tformlist(i); 
        Jregistered = imwarp(J,tform,'OutputView',imref2d(size(I)));
        Jregistered_cube(:,:,i) = Jregistered;
    end
end