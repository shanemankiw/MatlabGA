%���캯��
function [newpop2]=mutation(newpop1,pm,popsize,num,offset,length)

%������ƣ�
%ʹ��ÿ��Ԫ�ض�����offset��Χ�ڵĸ���
%�������ظ�����ͱ߽����
for i=1:popsize
    if(rand<pm)
        for j=1:num
            r = randi([-offset offset],1,num);
            %�������һ����offsetΪ���
            %�������п��ܵ�һά����
            newpop2(i,j)=newpop1(i,j)+r(1,j);
            if newpop2(i,j)<1||newpop2(i,j)>length
                newpop2(i,j)=newpop1(i,j);
            end
            %Խ�����
        end
    else
        newpop2(i,:)=newpop1(i,:);
    end
    
    newpop2(i,:)=sort(newpop2(i,:));
    
    flag=1;
            while flag
                flag=0;
                for k=2:num
                    if newpop2(i,k)==newpop2(i,k-1)
                        flag=1;
                        if k<=ceil(num/2+1)
                            newpop2(i,k)=newpop2(i,k)+1;
                        else
                            newpop2(i,k-1)=newpop2(i,k-1)-1;
                        end
                        %�ظ�����취��
                        %����ǰһ��������1�����Ǻ�һ�������-1
                        %��֤���ڷ�Χ֮��
                        %�������ظ��򷴸����
                    end
                end
            end
            %�ظ�����
end