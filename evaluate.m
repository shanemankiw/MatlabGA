%�ɱ�����������Ӧ�ȣ����㡢����ɸѡ����
function [price,poptemp]=evaluate(M,length,data3,popsize,pop)

grade=zeros(popsize,M,length);
%��ʼ��һ��ȫ���������������ߵĲ�ֵ
cost=0;
%
for i=1:popsize
    for j=1:M
        for k=1:length
            grade(i,j,k)=ceil(abs(data3(j,i,k)-k)/0.5);
            %�������ɱ�����Ĺ�ʽ������
            %���þ���ֵ������ȡ��������
            %����ÿ���¶ȵ�֮������
            
            %����ɱ����������
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
    %���M�������ƽ��ֵ
    price(i,1)=cost/M;
    cost=0;
end

%�����Ÿ���������Ѹ���

[minprice,mn]=min(price);
array(:)=sort(price);
%��price�ӵ͵������򸳸�array
%��array��n)������Ϊһ��ָʾ
%�˴�Ϊ�޳�Ⱥ���м۸���ߵ�1/5������
%�������Ÿ���
for i=1:popsize
    if price(i,1)>array((4*popsize)/5)
            poptemp(i,:)=pop(mn,:);
            price(i,1)=minprice;
    else
            poptemp(i,:)=pop(i,:);         
    end
end

                        
