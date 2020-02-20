%数据获取函数
function [popdata]=getdata(pop,voltage,num,popsize,M)

popdata=zeros(M,popsize,num);
%先预分配内存（以全零阵的形式

%将对应的电压值赋给popdata
for i=1:M
    for j=1:popsize
        for k=1:num
        popdata(i,j,k)=voltage(i,pop(j,k));
        end
    end
end
