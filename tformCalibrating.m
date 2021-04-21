function tformCalibrating(ImageFolder,ROIRectangle)
% tformCalibrating ��������ͼƬ������ļ�����ROI,չʾУ��Ч��(ROI)����һ���ļ��к�������м���У�����ͼƬ(ȫ��)��
    [pathstr,name]=fileparts(ImageFolder);
    mkdir(pathstr,[name,'(����У����)']);
    [imageFileNames,~,WaveLength] = getImageFileNames(ImageFolder);
    
    load tform.mat tformlist;
    load tform.mat BaseWavelength;
    I = imread(imageFileNames{WaveLength == BaseWavelength});
    for i = 1:length(imageFileNames)
        J = imread(imageFileNames{i});
        [pathstr,name,ext]=fileparts(imageFileNames{i});
        tform = tformlist(i); 
        Jregistered = imwarp(J,tform,'OutputView',imref2d(size(I)));
        figure(1);
        subplot(1,2,1);
        imshowpair(imcrop(I,ROIRectangle), imcrop(J,ROIRectangle),'blend','Scaling','joint');
        title([num2str(WaveLength(i)) 'nmԭͼ��']);
        subplot(1,2,2);
        imshowpair(imcrop(I,ROIRectangle), imcrop(Jregistered,ROIRectangle),'blend','Scaling','joint');
        title([num2str(WaveLength(i)) 'nm��׼ͼ��']);
        imwrite(Jregistered,[pathstr,'(����У����)','/',name,'(����У����)',ext]);
        pause(0.05);
    end
end