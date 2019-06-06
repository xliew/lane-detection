close all;clear all;clc;

I=imread('img.jpg');
[M,N]=size(I);


K=100;          %��������������
sigma=1;        %�������ֱ�������ݾ����ƫ��
pretotal=0;     %�������ģ�͵����ݵĸ���
k=1;
while pretotal < size(data,1)*2/3 &&  k<K      %��2/3�����ݷ������ģ�ͻ�ﵽ�����������Ϳ����˳���
    SampIndex=floor(1+(size(data,1)-1)*rand(3,1));  %������������������������ã�floor����ȡ��
    
    samp1=data(SampIndex(1),:);     %��ԭ�������������������
    samp2=data(SampIndex(2),:);
    samp3=data(SampIndex(3),:);
    
    line=RANSACline([samp1;samp2;samp3]);      %������������ϳ�ֱ�ߣ�������������Ϸ���
    mask=abs(line*[data ones(size(dat ,a,1),1)]');    %��ÿ�����ݵ����ֱ�ߵľ���
    total=sum(mask<sigma);          %�������ݾ���ֱ��С��һ����ֵ�����ݵĸ���
    
    if total>pretotal            %�ҵ��������ֱ�������������ֱ��
        pretotal=total;
        bestline=line;          %�ҵ���õ����ֱ��
    end  
    k=k+1;
end

%��ʾ���������ϵ�����
mask=abs(bestline*[data ones(size(data,1),1)]')<sigma;    
hold on;
for i=1:length(mask)
    if mask(i)
        plot(data(i,1),data(i,2),'+');
    end
end