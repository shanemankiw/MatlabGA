%成本（类似于适应度）计算、初步筛选函数
function [price,poptemp]=evaluate(M,length,data3,popsize,pop)

grade=zeros(popsize,M,length);
%初始化一个全零矩阵用来存放两者的差值
cost=0;
%
for i=1:popsize
    for j=1:M
        for k=1:length
            grade(i,j,k)=ceil(abs(data3(j,i,k)-k)/0.5);
            %根据误差成本估算的公式特殊性
            %可用绝对值函数、取整函数等
            %计算每个温度点之间的误差
            
            %计算成本的条件语句
            switch grade(i,j,k)
                case{0,1} 
                case(2) 
                    cost=cost+1;
                case(3) 
                    cost=cost+5;
                case(4) 
                    cost=cost+10;
                otherwise
                    cost=cost+10000;
            end
        end
    end
    %求解M个个体的平均值
    price(i,1)=cost/M;
    cost=0;
end

%用最优个体替代不佳个体

[minprice,mn]=min(price);
array(:)=sort(price);
%将price从低到高排序赋给array
%则array（n)可以作为一个指示
%此处为剔出群体中价格最高的1/5个个体
%换以最优个体
for i=1:popsize
    if price(i,1)>array((4*popsize)/5)
            poptemp(i,:)=pop(mn,:);
            price(i,1)=minprice;
    else
            poptemp(i,:)=pop(i,:);         
    end
end

                        
