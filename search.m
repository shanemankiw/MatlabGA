%�ȶ��㸽���ı�������
clear
clc
data = dlmread ( 'dataform20160902.csv' ) ;
%��������Χָ��
a1 = 3:5;
a2 = 18:21;
a3 = 25:28;
a4 = 70:74;
a5 = 86:88;
right = [ ] ;
for i=1:size(a1,2)
    for j=1:size(a2,2)
        for k=1:size(a3,2)
            for m=1:size(a4,2)
                for n=1:size(a5,2)
    answer=[a1(i),a2(j),a3(k),a4(m),a5(n)];
    %����Ϊ��ϡ��ɱ����㺯��
    %���������е�evaluate��fittingһ��
       for o=1:500
    x = data(2*o,answer(:));
    y=answer;
        xx=data(2*o,:);
        pp=spline(x,y);
        fittingdata(o,:)=ppval(pp,xx);
       end
grade=zeros(500,90);
cost=0;
price=0;

    for p=1:500
        for q=1:90
            grade(p,q)=ceil(abs(fittingdata(p,q)-q)/0.5);
            switch grade(p,q)
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
        price=price+cost;
        cost=0;
    end
    price=price/500+250;

%�������
if (price<262)
        tmp = [price,answer];
        right=[right;tmp];
end
                end
            end
        end
    end
end
right = sortrows(right,1); %����
dlmwrite ( 'bests.csv ' , right ) ;%������ļ�