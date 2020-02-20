%求出当前种群中最大适应度、最大适应度个体

function [bestindividual,lowestprice]=best(pop,price,popsize)
bestindividual=pop(1,:);
lowestprice=price(1,1);
for i=2:popsize
        if price(i,1)<lowestprice
                bestindividual=pop(i,:);
                lowestprice=price(i,1);
        end
end