tic
clear
clc
num=4;
%标定数字的个数
%如果还采用背包问题中的90个全随机，计算难度过大
M=500;
%个体总数
popsize=100;
%种群大小
length=90;
%可选择的长度（此处为温度）
pc=0.9;
%交叉概率
normalpm = 0.3;
%正常变异概率
highpm = 0.8;
%高变异概率
pm=normalpm;

offset=1;
%变异偏差
Q=50;
%标定成本

voltage=zeros(M,length);
origin=xlsread('dataform20160902.csv');
for i=1:M
    voltage(i,:)=origin(2*i ,:);
end
%将电压数据存入voltage矩阵

    pop=initpop(popsize,length,num);
    %随机产生个体，初始化种群


    popdata=getdata(pop,voltage,num,popsize,M);
    %从电压数据文件中获得电压数据
    data3=fitting(pop,popsize,M,popdata,voltage);
    %根据数据进行拟合，得到拟合出的温度数据
    [price,poptemp]=evaluate(M,length,data3,popsize,pop);
    %进行误差成本（类似于适应度）的计算
    for i=1:100
%遗传代数（迭代次数
%出于时间成本考虑，次数不应过大
%处于精确度考虑，次数不可过少
    [newpop,pm]=selection(popsize,price,poptemp,num,normalpm,highpm);
    %通过锦标赛选择成为母代的个体
    newpop1=crossover(newpop,pc,popsize,num);
    %交叉操作
    newpop2=mutation(newpop1,pm,popsize,num,offset,length);
    %变异操作
    popdata=getdata(newpop2,voltage,num,popsize,M);
    %从电压数据文件中获得电压数据
    data3=fitting(newpop2,popsize,M,popdata,voltage);
    %根据数据进行拟合，得到拟合出的温度数据
    [price,poptemp2]=evaluate(M,length,data3,popsize,newpop2);
    %计算种群中个体成本
    [bestindividual,lowestprice]=best(poptemp2,price,popsize);
    %求出群体中成本最低个体极其成本
    
    %pricemean=mean(price);
    %y1=pricemean;
    y2=lowestprice;
   
    
        plot(i,y2,'g*');
        hold on
        title('遗传算法插值标定');
        xlabel('进化代数');
        ylabel('价格');
        legend('最低成本','location','best');
        poptemp=poptemp2;
        %更新种群
end

[z,index]=min(price);
bestprice=z+num*Q
bestchoice=bestindividual
toc