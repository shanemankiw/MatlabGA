function [pop]=initpop(popsize,length,num)

for i=1:popsize
vector=sort(randperm(length,num));
%������ɾ��ȷֲ���1-90����������
pop(i,:)=vector(:);
%����ֵ����pop
end