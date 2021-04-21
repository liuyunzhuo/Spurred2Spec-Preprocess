function Jregistered_cube = tformCalibratingnoshow(ImageFolder)
% tformCalibrating ��������ͼƬ������ļ���,����һ���ļ��к�������м���У�����ͼƬ(ȫ��)��
    [pathstr,name]=fileparts(ImageFolder);
    mkdir(pathstr,[name,'(����У����)']);
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