%交叉函数
function [newpop1]=crossover(newpop,pc,popsize,num)

%交叉机制：实值中间插值交叉
%先随机出一个交配切入点
%切入点前不变
%切入点后两个相邻父辈的相同位置基因
%通过随机函数产生两个介于两者之间的随机实值
%作为所产生两个子代分别的基因值
for i=1:2:popsize-1
%相邻两父辈交配
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