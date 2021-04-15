Img=imread('a/000028.jpg');
Img2=imread('b/000028.jpg');
[n m a]=size(Img);%判断图像的大小

% [J1,J2]= rectifyStereoImages(Img,Img2,stereoParams);

% subplot(2,4,1);imshow(J1);
% subplot(2,4,2);imshow(J2);
% subplot(2,4,3);imshow(Img);
% subplot(2,4,4);imshow(Img2);

% 立体匹配


I1 = Img;
I2 =Img2;
figure
imshowpair(I1, I2, 'montage');
title('Original Images');

%加载stereoParameters对象。
load('matlab_jieguo.mat');%加载你保存的相机标定的mat

[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
figure
imshowpair(J1, J2, 'montage');
title('Undistorted Images');

% 立体图像校正将图像投影到共同的图像平面上，使得对应的点具有相同的行坐标。
% 我们完成了校正之后，我们再进行特征点匹配就能将两张图联系到一起，进而求得距离信息。

figure; imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%图像显示50%


WL1 = abs(imfilter(rgb2gray(J1), fspecial('Laplacian'), 'replicate', 'conv'));
WL2 = abs(imfilter(rgb2gray(J2), fspecial('Laplacian'), 'replicate', 'conv'));
WL1(WL1(:)>=WL2(:)) = 1;WL1(WL1(:)<WL2(:)) = 0;
WL2(WL1(:)>=WL2(:)) = 0;WL2(WL1(:)<WL2(:)) = 1;
J_F(:,:,1) = J1(:,:,1).*WL1+J2(:,:,1).*WL2;
J_F(:,:,2) = J1(:,:,2).*WL1+J2(:,:,2).*WL2;
J_F(:,:,3) = J1(:,:,3).*WL1+J2(:,:,3).*WL2;
figure; imshow(J_F, 'InitialMagnification', 50);%图像显示50%

J1 = rgb2gray(J1);
J2 = rgb2gray(J2);
disparityRange = [0 48];
disparityMap = disparitySGM(J1,J2,'DisparityRange',disparityRange,'UniquenessThreshold',1);
figure
imshow(disparityMap, [-5 10])
title('Disparity Map')
colormap jet
colorbar

disparityMap = disparitySGM((J1),(J2));
figure 
imshow(disparityMap,[0,64],'InitialMagnification',50);
%disparityMap = disparity(rgb2gray(J1), rgb2gray(J2), 'BlockSize',15,'DisparityRange',[0,400],'BlockSize',15,'ContrastThreshold',0.5,'UniquenessThreshold',15);


% 其中：
% ’BlockMatching’或’SemiGlobal’：视差估计算法的一种（该种算法为默认算法），通过比较图像中每个像素块的绝对差值之和（SAD）来计算视差。
% （块匹配采用了基本块匹配1.Konolige，K。，Small Vision Systems：Hardware and Implementation，Proceedings of the 8th International Symposium in Robotic Research，pages 203-212,1997。或者半全局块匹配2.Hirschmuller, H., Accurate and Efficient Stereo Processing by Semi-Global Matching and Mutual Information, International Conference on Computer Vision and Pattern Recognition, 2005.）
% 
% ’DisparityRange’,[0,400]：视差范围，范围可以自己设定，不能超过图像的尺寸，当双目距离较远或者物体距离较近时，应适当增大该参数的值。
% 
% ’BlockSize’, 15：设置匹配时方块大小。
% 
% ’ContrastThreshold’,0.5：对比度的阈值，阈值越大，错误匹配点越少，能匹配到的点也越少。
% 
% ’UniquenessThreshold’,15：唯一性阈值，设置值越大，越破坏了像素的唯一性，设置为0，禁用该参数。
% 
% ’DistanceThreshold’,400：从图像左侧到右侧检测的最大跨度，跨度越小越准确，但很容易造成无法匹配。禁用该参数[]。
% 
% ’TextureThreshold’,0.0002（默认）：最小纹理阈值，定义最小的可靠纹理，越大越造成匹配点少，越少越容易匹配到小纹理，引起误差。
% 整体计算的步骤：
% 1.使用Sobel滤波器计算图像对比度的度量。
% 2.通过使用块匹配和绝对差值之和（SAD）来计算每个像素的视差。
% 3.标记包含不可靠的像素 差异值。该函数将像素设置为 - realmax（’ single’）返回的值。
% 链接：https://blog.csdn.net/a6333230/article/details/88245102



pointCloud3D = reconstructScene(disparityMap, stereoParams);
 pointCloud3D = double(pointCloud3D);
 pointCloud3D = pointCloud3D/100;

%  Z = double(pointCloud3D(:,:,3));
% mask = repmat(Z> 5&Z <6,[1,1,3]);
% J1(~mask)= 0;
% figure;imshow(J1,'InitialMagnification',50);



% [m n]=size(Img);
% 
% w=3;       %模板半径
% depth=5;    %最大偏移距离，同样也是最大深度距离
% imgn=zeros(m,n);
% for i=1+w:m-w
%    for j=1+w+depth:n-w 
%        tmp=[];
%        lwin=Img(i-w:i+w,j-w:j+w);
%        for k=0:-1:-depth        
%            rwin=Img2(i-w:i+w,j-w+k:j+w+k);
%            diff=lwin-rwin;
%            tmp=[tmp sum(abs(diff(:)))];
%        end
%        [junk imgn(i,j)]=min(tmp);   %获得最小位置的索引
%    end
% end
% 
% imshow(imgn,[])
