%���溯��
function [newpop1]=crossover(newpop,pc,popsize,num)

%������ƣ�ʵֵ�м��ֵ����
%�������һ�����������
%�����ǰ����
%�������������ڸ�������ͬλ�û���
%ͨ�������������������������֮������ʵֵ
%��Ϊ�����������Ӵ��ֱ�Ļ���ֵ
for i=1:2:popsize-1
%��������������
    if(rand<pc)
                cpoint=round(rand*num);
                for j=1:cpoint
                newpop1(i,j)=newpop(i,j);
                newpop1(i+1,j)=newpop(i+1,j);
                end
                for j=cpoint+1:num
                newpop1(i,j)=round(newpop(i,j)+(newpop(i+1,j)-newpop(i,j))*rand);
                newpop1(i+1,j)=round(newpop(i,j)+(newpop(i+1,j)-newpop(i,j))*rand);
                end
    else
                newpop1(i,:)=newpop(i,:);
                newpop1(i+1,:)=newpop(i+1,:);
    end
        
end