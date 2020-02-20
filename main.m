tic
clear
clc
num=4;
%�궨���ֵĸ���
%��������ñ��������е�90��ȫ����������Ѷȹ���
M=500;
%��������
popsize=100;
%��Ⱥ��С
length=90;
%��ѡ��ĳ��ȣ��˴�Ϊ�¶ȣ�
pc=0.9;
%�������
normalpm = 0.3;
%�����������
highpm = 0.8;
%�߱������
pm=normalpm;

offset=1;
%����ƫ��
Q=50;
%�궨�ɱ�

voltage=zeros(M,length);
origin=xlsread('dataform20160902.csv');
for i=1:M
    voltage(i,:)=origin(2*i ,:);
end
%����ѹ���ݴ���voltage����

    pop=initpop(popsize,length,num);
    %����������壬��ʼ����Ⱥ


    popdata=getdata(pop,voltage,num,popsize,M);
    %�ӵ�ѹ�����ļ��л�õ�ѹ����
    data3=fitting(pop,popsize,M,popdata,voltage);
    %�������ݽ�����ϣ��õ���ϳ����¶�����
    [price,poptemp]=evaluate(M,length,data3,popsize,pop);
    %�������ɱ�����������Ӧ�ȣ��ļ���
    for i=1:100
%�Ŵ���������������
%����ʱ��ɱ����ǣ�������Ӧ����
%���ھ�ȷ�ȿ��ǣ��������ɹ���
    [newpop,pm]=selection(popsize,price,poptemp,num,normalpm,highpm);
    %ͨ��������ѡ���Ϊĸ���ĸ���
    newpop1=crossover(newpop,pc,popsize,num);
    %�������
    newpop2=mutation(newpop1,pm,popsize,num,offset,length);
    %�������
    popdata=getdata(newpop2,voltage,num,popsize,M);
    %�ӵ�ѹ�����ļ��л�õ�ѹ����
    data3=fitting(newpop2,popsize,M,popdata,voltage);
    %�������ݽ�����ϣ��õ���ϳ����¶�����
    [price,poptemp2]=evaluate(M,length,data3,popsize,newpop2);
    %������Ⱥ�и���ɱ�
    [bestindividual,lowestprice]=best(poptemp2,price,popsize);
    %���Ⱥ���гɱ���͸��弫��ɱ�
    
    %pricemean=mean(price);
    %y1=pricemean;
    y2=lowestprice;
   
    
        plot(i,y2,'g*');
        hold on
        title('�Ŵ��㷨��ֵ�궨');
        xlabel('��������');
        ylabel('�۸�');
        legend('��ͳɱ�','location','best');
        poptemp=poptemp2;
        %������Ⱥ
end

[z,index]=min(price);
bestprice=z+num*Q
bestchoice=bestindividual
toc