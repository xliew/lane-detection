clc;clear;close all;
%-------------��������-------------------
ObjDir = 'D:\��ҵ������\Ԥ����Ĵ���\test_image\'; %Ŀ��ͼƬ�ļ���·��
OutputDir = 'D:\��ҵ������\Ԥ����Ĵ���\test_image_output\'; %����ļ���·��
number = 86;

%ͼƬ����Ϊ��i.png i=1....number
%---------------------------------------
for num = 8:1:number
 bgfile = [ObjDir, int2str(num),'.png']; %����ͼƬ������·��
img_original = imread(bgfile);        %����ͼƬ
R = img_original( :, :, 1);
G = img_original( :, :, 2);
B = img_original( :, :, 3);
img_RGB2B= R+G-B;
figure,imshow(img_RGB2B);
img_doublepri=im2double(img_RGB2B);
[M,N]=size(img_RGB2B);
img_double=img_doublepri(M*0.2:M*0.75,N*0.1:N*0.9);
figure,imshow(img_double);
B=mean(img_doublepri,2);
figure,plot(B);
%�ָ�ͼ��ˮƽ����ȡ
  %����ÿ�е�ƽ���Ҷ�ֵ
A = mean(img_double,2);
figure,plot(A);
[min_of_A,loc_of_A] = min(A);
img_road = img_doublepri(loc_of_A+M*0.3:M*0.75,N*0.05:N*0.95);
figure, imshow(img_road);

%ͼ��ƽ��
%��ֵ�˲�  ����img_road double����
img_median_filter = medfilt2(img_road);
figure,imshow(img_median_filter);

% %�����䷽��/ͼ��ֿ���ֵ����
% OTSU = @(block_struct) im2bw(block_struct.data, graythresh(block_struct.data));
% img_blk = blockproc(img_median_filter,[25,65],OTSU);
% figure,imshow(img_blk);
% 
% % img_blk2 = medfilt2(img_blk);


%��Ե���
img_canny = edge (img_median_filter, 'canny');
figure,imshow(img_canny);
Im=img_canny;
%��ʼ�ֿ�
imshow(Im)
hold on
L = size(Im);
height=24;
width=65;
max_row = floor(L(1)/height);%ʵ��ͼƬΪ280*1024����max_row=7,max_col=32
max_col = floor(L(2)/width);
seg = cell(max_row,max_col);
%�ֿ�����������һ��
for row = 1:max_row      
    for col = 1:max_col        
    seg(row,col)= {Im((row-1)*height+1:row*height,(col-1)*width+1:col*width,:)}; 
    end
end 
for i=1:max_row*max_col
    [H,theta,rho] = hough(seg{i});
    P = houghpeaks(H,2);
    lines = houghlines(seg{i},theta,rho,P,'Fillgap',5,'Minlength',15);
    seg{i}=double(seg{i});
     for k = 1:length(lines)   
         if lines(k).theta<-70 ||lines(k).theta>70
              seg{i}=seg{i}.*0;
         end
     end
%     imwrite(seg{i},strcat('m',int2str(i),'.jpg'));   %�ѵ�i֡��ͼƬдΪ'mi.bmp'����
end
%�����ֿ�ı߽�
for row = 1:max_row      
    for col = 1:max_col  
 rectangle('Position',[width*(col-1),height*(row-1),width,height],...
         'LineWidth',2,'LineStyle','-','EdgeColor','r');
        end
end 

hold off
img = cell2mat(seg);
figure,imshow(img);
hold on

%---------ֱ�߳�����ģ�ͽ������Ľ�Hough�任���-----------------
%��һ��������ֱ�߳���ģ��
%��ֱ�߼�������
%�õ�����ռ�
%��ֱ�߼�������
%�õ�����ռ�
[H1,T1,R1] = hough(img,'Theta',25:0.1:40);

%��ֵ��
Peaks=houghpeaks(H1,1);

%�õ��߶���Ϣ
lines=houghlines(img,T1,R1,Peaks);

%�����߶�
 for k=1:length(lines)
xy=[lines(k).point1;lines(k).point2];   
plot(xy(:,1),xy(:,2),'LineWidth',4);
 end
 
 %�ҷ�ֱ�߼�������
[H2,T2,R2] = hough(img,'Theta',-40:0.1:-25);
Peaks1=houghpeaks(H2,1);
lines1=houghlines(img,T2,R2,Peaks1,'FillGap',25);

for k=1:length(lines1)
xy1=[lines1(k).point1;lines1(k).point2];   
plot(xy1(:,1),xy1(:,2),'LineWidth',4);
end

   gfframe=getframe(gcf);
   gffim=frame2im(gfframe);
   imwrite(gffim,[OutputDir,int2str(num),'.png']);%��������ͼƬ���浽Ŀ���ļ���  
   close all;
end

      
    








