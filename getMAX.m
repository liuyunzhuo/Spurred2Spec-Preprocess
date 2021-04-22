function getMAX()
    load a.mat a;
    maxval = 0;
    % ѭ����ȡ����1-57
    for i=1:57
        InputFolder = ['./����������ѵ��������/For_Train/����ͼ��/',num2str(i)];
        [imageFileNames,FileNum,~] = getImageFileNames(InputFolder);
        [sz1,sz2] = size(imread(imageFileNames{1}));
        I_cube = zeros(sz1,sz2,FileNum);
        for j = 1:FileNum
            J = im2double(imread(imageFileNames{j}));
            I_cube(:,:,j) = J.*a(j);
        end
        maxval = max(maxval,max(I_cube,[],'all'));
    end
    % ѭ����ȡ����58-63
    for i=58:63
        InputFolder = ['./����������ѵ��������/For_Test/����ͼ��/',num2str(i)];
        [imageFileNames,FileNum,~] = getImageFileNames(InputFolder);
        [sz1,sz2] = size(imread(imageFileNames{1}));
        I_cube = zeros(sz1,sz2,FileNum);
        for j = 1:FileNum
            J = im2double(imread(imageFileNames{j}));
            I_cube(:,:,j) = J.*a(j);
        end
        maxval = max(maxval,max(I_cube,[],'all'));
    end
    disp(['ѵ��������Լ������й����������ȫ�����ֵΪ��' num2str(maxval)]);
    save('a.mat','maxval','-append');
    disp('a.mat�������Ϣ����:');
    whos('-file','a.mat');
end