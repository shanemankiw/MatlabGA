%���ƶȼ��㺯��
function sim=similar(sample)
sizenum=size(sample,1);
sim=0;
for i=1:sizenum
    for j=1:sizenum
        sim=sim+sum(abs(sample(i,:)-sample(j,:)));%�����ֵ
    end
end
sim=sim/(sizenum^2);%������ѧ��ʽ����