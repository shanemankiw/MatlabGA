function [pop]=initpop(popsize,length,num)

for i=1:popsize
vector=sort(randperm(length,num));
%随机生成均匀分布的1-90的整数向量
pop(i,:)=vector(:);
%将其值赋给pop
end