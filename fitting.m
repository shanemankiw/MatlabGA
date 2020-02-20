%拟合函数

function [fittingdata]=fitting(pop,popsize,M,popdata,voltage)


for i=1:M
    for j=1:popsize
        x=popdata(i,j,:);
        y=pop(j,:);
        xx=voltage(i,:);
        pp=spline(x,y);
        %以电压为x坐标，温度为y坐标，对函数进行拟合
        fittingdata(i,j,:)=ppval(pp,xx);
        %插值，得到结果赋给fittingdata
    end
end
    