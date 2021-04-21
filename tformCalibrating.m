function tformCalibrating(ImageFolder,ROIRectangle)
% tformCalibrating 函数输入图片储存的文件夹与ROI,展示校正效果(ROI)创建一个文件夹后输出所有几何校正后的图片(全幅)。
    [pathstr,name]=fileparts(ImageFolder);
    mkdir(pathstr,[name,'(几何校正后)']);
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
        title([num2str(WaveLength(i)) 'nm原图像']);
        subplot(1,2,2);
        imshowpair(imcrop(I,ROIRectangle), imcrop(Jregistered,ROIRectangle),'blend','Scaling','joint');
        title([num2str(WaveLength(i)) 'nm配准图像']);
        imwrite(Jregistered,[pathstr,'(几何校正后)','/',name,'(几何校正后)',ext]);
        pause(0.05);
    end
end