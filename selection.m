% ѡ����
% ������Щ������Խ�����һ��
%������ѡ����������̶ĸ���Ч�ķ�ʽ
% ������ѡ�񷨳���

function [newpop,pm]=selection(popsize,price,newpop,num,normalpm,highpm)
Tour=4;%ÿ�ֽ������Ĳ�������
popSorted=popSort(newpop,price);
sim=similar(popSorted(:,:));
if(sim<=24)%���ƶȹ��������ͻ����
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
        if(Tournament(m)<Tournament(m-1))%����ľ���
            I=r(m);
        end
    end
    newpop(r0(j),:)=popSorted(I,:);
end
%�������̶�ѡ���ʵ��
% fitness=1./price;
% %��price�ĵ�����Ϊ���̶�ʹ�õ�fitness
% totalfit=sum(fitness);                                           
% %����Ӧֵ֮��
% fitness=fitness/totalfit;                                       
% %�������屻ѡ��ĸ���
% fitness=cumsum(fitness);            
% %cumsumΪ�ۼӼ��㺯��
% rvector=sort(rand(popsize,1));
% %sortΪ��С��������
% 
% old=1;
% new=1;
% while new<=popsize
%     %ѡ��100���¸���
%     if(rvector(new))<fitness(old)
%         newpop(new,:)=poptemp(old,:);
%         new=new+1;
%     else
%         old=old+1;
%     end
% end