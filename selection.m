% 选择复制
% 决定哪些个体可以进入下一代
%本程序选择相对于轮盘赌更有效的方式
% 锦标赛选择法程序

function [newpop,pm]=selection(popsize,price,newpop,num,normalpm,highpm)
Tour=4;%每轮锦标赛的参赛队伍
popSorted=popSort(newpop,price);
sim=similar(popSorted(:,:));
if(sim<=24)%相似度过大，则提高突变率
    pm=highpm;
else
    pm=normalpm;
end

r0=randi(popsize,1,popsize/2);
for j=1:popsize/2
    r=randi(popsize,1,Tour);
    Tournament=zeros(1,Tour);
    for k=1:Tour
        Tournament(k)=price(r(k));
    end
    I=r(1);
    for m=2:Tour
        if(Tournament(m)<Tournament(m-1))%锦标的竞争
            I=r(m);
        end
    end
    newpop(r0(j),:)=popSorted(I,:);
end
%附：轮盘赌选择的实现
% fitness=1./price;
% %将price的倒数作为轮盘赌使用的fitness
% totalfit=sum(fitness);                                           
% %求适应值之和
% fitness=fitness/totalfit;                                       
% %单个个体被选择的概率
% fitness=cumsum(fitness);            
% %cumsum为累加计算函数
% rvector=sort(rand(popsize,1));
% %sort为从小到大排列
% 
% old=1;
% new=1;
% while new<=popsize
%     %选出100个新个体
%     if(rvector(new))<fitness(old)
%         newpop(new,:)=poptemp(old,:);
%         new=new+1;
%     else
%         old=old+1;
%     end
% end