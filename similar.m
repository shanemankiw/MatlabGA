%相似度计算函数
function sim=similar(sample)
sizenum=size(sample,1);
sim=0;
for i=1:sizenum
    for j=1:sizenum
        sim=sim+sum(abs(sample(i,:)-sample(j,:)));%计算差值
    end
end
sim=sim/(sizenum^2);%根据数学公式计算