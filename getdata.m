%���ݻ�ȡ����
function [popdata]=getdata(pop,voltage,num,popsize,M)

popdata=zeros(M,popsize,num);
%��Ԥ�����ڴ棨��ȫ�������ʽ

%����Ӧ�ĵ�ѹֵ����popdata
for i=1:M
    for j=1:popsize
        for k=1:num
        popdata(i,j,k)=voltage(i,pop(j,k));
        end
    end
end
