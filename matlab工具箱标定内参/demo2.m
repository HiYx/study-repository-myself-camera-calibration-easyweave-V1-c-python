Img=imread('a/000028.jpg');
Img2=imread('b/000028.jpg');
[n m a]=size(Img);%�ж�ͼ��Ĵ�С

% [J1,J2]= rectifyStereoImages(Img,Img2,stereoParams);

% subplot(2,4,1);imshow(J1);
% subplot(2,4,2);imshow(J2);
% subplot(2,4,3);imshow(Img);
% subplot(2,4,4);imshow(Img2);

% ����ƥ��


I1 = Img;
I2 =Img2;
figure
imshowpair(I1, I2, 'montage');
title('Original Images');

%����stereoParameters����
load('matlab_jieguo.mat');%�����㱣�������궨��mat

[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);
figure
imshowpair(J1, J2, 'montage');
title('Undistorted Images');

% ����ͼ��У����ͼ��ͶӰ����ͬ��ͼ��ƽ���ϣ�ʹ�ö�Ӧ�ĵ������ͬ�������ꡣ
% ���������У��֮�������ٽ���������ƥ����ܽ�����ͼ��ϵ��һ�𣬽�����þ�����Ϣ��

figure; imshow(cat(3, J1(:,:,1), J2(:,:,2:3)), 'InitialMagnification', 50);%ͼ����ʾ50%


WL1 = abs(imfilter(rgb2gray(J1), fspecial('Laplacian'), 'replicate', 'conv'));
WL2 = abs(imfilter(rgb2gray(J2), fspecial('Laplacian'), 'replicate', 'conv'));
WL1(WL1(:)>=WL2(:)) = 1;WL1(WL1(:)<WL2(:)) = 0;
WL2(WL1(:)>=WL2(:)) = 0;WL2(WL1(:)<WL2(:)) = 1;
J_F(:,:,1) = J1(:,:,1).*WL1+J2(:,:,1).*WL2;
J_F(:,:,2) = J1(:,:,2).*WL1+J2(:,:,2).*WL2;
J_F(:,:,3) = J1(:,:,3).*WL1+J2(:,:,3).*WL2;
figure; imshow(J_F, 'InitialMagnification', 50);%ͼ����ʾ50%

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


% ���У�
% ��BlockMatching����SemiGlobal�����Ӳ�����㷨��һ�֣������㷨ΪĬ���㷨����ͨ���Ƚ�ͼ����ÿ�����ؿ�ľ��Բ�ֵ֮�ͣ�SAD���������Ӳ
% ����ƥ������˻�����ƥ��1.Konolige��K����Small Vision Systems��Hardware and Implementation��Proceedings of the 8th International Symposium in Robotic Research��pages 203-212,1997�����߰�ȫ�ֿ�ƥ��2.Hirschmuller, H., Accurate and Efficient Stereo Processing by Semi-Global Matching and Mutual Information, International Conference on Computer Vision and Pattern Recognition, 2005.��
% 
% ��DisparityRange��,[0,400]���ӲΧ����Χ�����Լ��趨�����ܳ���ͼ��ĳߴ磬��˫Ŀ�����Զ�����������Ͻ�ʱ��Ӧ�ʵ�����ò�����ֵ��
% 
% ��BlockSize��, 15������ƥ��ʱ�����С��
% 
% ��ContrastThreshold��,0.5���Աȶȵ���ֵ����ֵԽ�󣬴���ƥ���Խ�٣���ƥ�䵽�ĵ�ҲԽ�١�
% 
% ��UniquenessThreshold��,15��Ψһ����ֵ������ֵԽ��Խ�ƻ������ص�Ψһ�ԣ�����Ϊ0�����øò�����
% 
% ��DistanceThreshold��,400����ͼ����ൽ�Ҳ��������ȣ����ԽСԽ׼ȷ��������������޷�ƥ�䡣���øò���[]��
% 
% ��TextureThreshold��,0.0002��Ĭ�ϣ�����С������ֵ��������С�Ŀɿ�����Խ��Խ���ƥ����٣�Խ��Խ����ƥ�䵽С����������
% �������Ĳ��裺
% 1.ʹ��Sobel�˲�������ͼ��ԱȶȵĶ�����
% 2.ͨ��ʹ�ÿ�ƥ��;��Բ�ֵ֮�ͣ�SAD��������ÿ�����ص��Ӳ
% 3.��ǰ������ɿ������� ����ֵ���ú�������������Ϊ - realmax���� single�������ص�ֵ��
% ���ӣ�https://blog.csdn.net/a6333230/article/details/88245102



pointCloud3D = reconstructScene(disparityMap, stereoParams);
 pointCloud3D = double(pointCloud3D);
 pointCloud3D = pointCloud3D/100;

%  Z = double(pointCloud3D(:,:,3));
% mask = repmat(Z> 5&Z <6,[1,1,3]);
% J1(~mask)= 0;
% figure;imshow(J1,'InitialMagnification',50);



% [m n]=size(Img);
% 
% w=3;       %ģ��뾶
% depth=5;    %���ƫ�ƾ��룬ͬ��Ҳ�������Ⱦ���
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
%        [junk imgn(i,j)]=min(tmp);   %�����Сλ�õ�����
%    end
% end
% 
% imshow(imgn,[])
