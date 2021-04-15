%%1、读取显示摄像头:
camList = webcamlist;
cam1 = webcam(2);
cam1.Resolution='640x480';
%cam1.WhiteBalance=4193;
preview(cam1);
% img = snapshot(cam1);
% image(img);


%%操作第二个摄像头
cam2 = webcam(3);
cam2.Resolution='640x480';
cam2.Gamma=100;
% preview(cam2);

%加载stereoParameters对象。
load('matlab_jieguo.mat');%加载你保存的相机标定的mat

    fig1 = figure(1) ;
    fig1.Color = [1 1 1] ; 
    hold off;
    grid off    %
    title('Disparity Map')
    colormap jet
    colorbar

for idx = 1:500
    Img = snapshot(cam1);
    Img2 = snapshot(cam2);
    I1 = Img;
    I2 =Img2;
    [J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
    J1 = rgb2gray(J1);
    J2 = rgb2gray(J2);
    disparityRange = [0 48];
    disparityMap = disparityBM(J1,J2,'DisparityRange',disparityRange,'UniquenessThreshold',20);
    hold on;
    imshow(disparityMap, [-10 10])
    colorbar
    colormap jet
    hold off;
    
end



clear cam 