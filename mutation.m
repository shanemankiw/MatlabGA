%变异函数
function [newpop2]=mutation(newpop1,pm,popsize,num,offset,length)

%变异机制：
%使得每个元素都产生offset范围内的浮动
%并加入重复检验和边界检验
for i=1:popsize
    if(rand<pm)
        for j=1:num
            r = randi([-offset offset],1,num);
            %随机产生一个以offset为界的
            %正负皆有可能的一维向量
            newpop2(i,j)=newpop1(i,j)+r(1,j);
            if newpop2(i,j)<1||newpop2(i,j)>length
                newpop2(i,j)=newpop1(i,j);
            end
            %越界检验
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
                        %重复处理办法：
                        %若是前一半个体则加1，若是后一半个体则-1
                        %保证仍在范围之内
                        %若仍有重复则反复检测
                    end
                end
            end
            %重复检验
end