function getMAX()
    load a.mat a;
    maxval = 0;
    % 循环读取样本1-57
    for i=1:57
        InputFolder = ['./用于神经网络训练的数据/For_Train/光谱图像/',num2str(i)];
        [imageFileNames,FileNum,~] = getImageFileNames(InputFolder);
        [sz1,sz2] = size(imread(imageFileNames{1}));
        I_cube = zeros(sz1,sz2,FileNum);
        for j = 1:FileNum
            J = im2double(imread(imageFileNames{j}));
            I_cube(:,:,j) = J.*a(j);
        end
        maxval = max(maxval,max(I_cube,[],'all'));
    end
    % 循环读取样本58-63
    for i=58:63
        InputFolder = ['./用于神经网络训练的数据/For_Test/光谱图像/',num2str(i)];
        [imageFileNames,FileNum,~] = getImageFileNames(InputFolder);
        [sz1,sz2] = size(imread(imageFileNames{1}));
        I_cube = zeros(sz1,sz2,FileNum);
        for j = 1:FileNum
            J = im2double(imread(imageFileNames{j}));
            I_cube(:,:,j) = J.*a(j);
        end
        maxval = max(maxval,max(I_cube,[],'all'));
    end
    disp(['训练集与测试集中所有光谱立方体的全局最大值为：' num2str(maxval)]);
    save('a.mat','maxval','-append');
    disp('a.mat保存的信息如下:');
    whos('-file','a.mat');
end