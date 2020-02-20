function ma=main()
tic
e_hard=125000;
e_soft=4900;
e_manual=10;
e_watchdog=1;
N=10000;
global solution;
solution=[1,1,1];
global numOfConnect;
global manual;%�˹��������
global major;%�ش����ԭ���¼
major=zeros(1,3);
manual=0;
if solution(2)==1
    numOfConnect=29;
else
    numOfConnect=21;
end

Errors_normal=0;
Errors_major=0;
T_perfect=0;
T_no_normal=0;
T_no_major=0;
Test_ava=zeros(1,9);
for n=1:N
    t=0;
    errors_major=0;
    errors_normal=0;
    errtime_normal=0;
    errtime_major=0;
    last_major=0;
    last_normal=0;
    test_points=[1,2,8,20,100,1000,365*24,365*5*24,10*365*24];%���Ե�
    test_ava=ones(1,9);
%�������
hard_rand=exprnd(e_hard,1,(53+numOfConnect)*(4+solution(3))+19); %����
soft_rand=exprnd(e_soft,1,4+solution(3));
global rand_all;
rand_all=[hard_rand,soft_rand];
while t<3650*24
    t=min(rand_all);
    if t>87600
        break;
    end
    j=find(rand_all==t);
    tType=1;%��ʼ����ʱ���ǹ��Ͽ�ʼ
    [cur,cur_num]=makeQueue(j,t);
    if cur(size(cur,1),3)<87600
        last_normal=cur(size(cur,1),3);%���һ�����ϱ��޺�
    else %��ʱ��Ҫ���
        test_ava(9)=0;
        break;%������while
    end
    errs=zeros(1,2);
    errs(1,2)=t;
    errs(1,1)=errType(t,cur);
while isempty(cur)==0%���в��յ�ʱ��?
    eT=errType(t,cur);
    tType=getType(t,cur);
    if t~=errs(1,2)&&eT~=errs(size(errs,1),1)%���ǵ�һ����������һ������ͬ?
        errs=[errs;eT,t];
    end
    if tType==2%���Ͻ��������ʱ���ж����������
        rand_all(cur(1,1))=cur(1,4);   %��������ʱ��
%          manual=manual+1;
        cur(1,:)=[];        %����
        cur_num=cur_num-1;
    end
    if isempty(cur)==0
        t=nextTime(t,cur);%����һ��ʱ��?
    end

end
%ͨ��errs�������ָ��
errors_normal=errors_normal+1;   %���ϴ���
errors_major=errors_major+sum(find(errs(:,1)==1));      %�ش���ϴ���
errtime_normal=errtime_normal+(errs(size(errs,1),2)-errs(1,2));%����ʱ��
for i=1:size(errs,1)-1%�ش����ʱ��
    if errs(i,1)==1
        errtime_major=errtime_major+(errs(i+1,2)-errs(i,2));
    end
 end
if errs(size(errs,1)-1,1)==1
    last_major=last_normal;
end
%�����Բ���
ava_i=find(errs(size(errs,1),2)>=test_points&test_points>=errs(1,2));
for ai=ava_i
    test_ava(ai)=0;%������ ����
end
end
Test_ava=Test_ava+test_ava;
Errors_normal=Errors_normal+errors_normal;
Errors_major=Errors_major+errors_major;
T_perfect=T_perfect+(87600-errtime_normal);
T_no_normal=T_no_normal+(last_normal-errtime_normal)/errors_normal;
T_no_major=T_no_major+(last_major-errtime_major)/errors_major;
end
manual=manual/N;
Errors_normal=Errors_normal/N;
Errors_major=Errors_major/N;
T_perfect=T_perfect/N;
T_no_normal=T_no_normal/N;
T_no_major=T_no_major/N;
Test_ava=Test_ava/N;
data1=[manual,Errors_normal,Errors_major,T_perfect,T_no_normal,T_no_major];
%dlmwrite('Q3.csv',data1,'-append');
%dlmwrite('Q3.csv',Test_ava,'-append');
major=major/N;
dlmwrite('Q3.csv',major,'-append');
toc

function tType=getType(t,cur)
    tmp=cur(:,2:3);
    [~,tType]=find(tmp==t);     %�ڶ�����״̬1����������״̬2
function tnext=nextTime(t,cur)
    tmp=[cur(:,3),cur(:,2)];
    reshape(tmp,1,2*size(tmp,1));
    tnext=tmp(find(tmp>t,1));
function eT=errType(t,cur)
    global major;
    [row,~]=find(cur(:,2:3)==t);
    j=cur(row,1);%�ҵ���ǰt��j
    %����Ӱ������
    influence=0;
    influence(1)=[];
    for i=1:size(cur,1)
        if cur(i,3)>t &&cur(i,2)<=t
            influence=[influence,cur(i,1)];%Ӱ�����
        end
    end
    if isempty(influence)==1%��û��Ӱ�������ζ�ŵ��˵�ǰ�������һ��Ԫ���������
        eT=0;
        return
    end
    %���ɵ���Ӱ�����ӵĴ�������
    eS=0;
    eS(1)=[];
    for k=1:size(influence,2)
        eS=[eS,errSingle(influence(k))];
    end
    %�����Ƿ�����ش����
    if find(eS==1)
        eT=1;
        return
    else
        if size(eS,2)==1
            eT=eS;
            return
        end
        tmp=eS(1);
        if tmp<=4       %�ӻ�����
            for q=2:size(eS,2)+1
                 if eS(q)<=4
                    if tmp~=eS(q)
                        eT=1;
                        major=major+[0,0,1];
                        return
                    else
                        eT=tmp;
                        return
                    end
                 else
                     eT=7;
                     return
                 end
            end
        else
           for q=2:size(eS,2)+1
                 if eS(q)>4
                    if tmp~=eS(q)
                        eT=1;
                        major=major+[0,1,0];
                        return
                    else
                        eT=tmp;
                        return
                    end
                 else
                     eT=7;
                     return
                 end
           end
        end
    end

function [cur,cur_num]=makeQueue(j,t)
%A�޸���ʱ��A2
%���ʱ�����й��ϵĻ���ӣ������µ��޸�ʱ�䣬ֱ�����Ϊֹ
global rand_all;
cur=zeros(1,4);
cur(1,:)=[];
cur=enqueue(j,t,cur);%��һ���������?
cur_num=1;
i=1;
while true
    t_fixup=cur(size(cur,1),3);
    fixing=find(rand_all>t&rand_all<=t_fixup);%��ǰ�������޺�֮ǰ�������¶�������j����
    if isempty(fixing)==1
        break;
    end
%     t=cur(i,3);i=i+1;%ʱ�䲦����i���޺�
    t=t_fixup;  %ʱ������е���һ��ʱ���յ�
    while isempty(fixing)==0
        cur=enqueue(fixing(1),rand_all(fixing(1)),cur);
        cur_num=cur_num+1;
        fixing(1)=[];%��һ�����ӣ�fixing����
    end
end

function cur=enqueue(j,t,cur)
    e_hard=125000;e_soft=4900;e_manual=10;e_watchdog=1;
    global solution;
    global manual;
    if objectType(j)==1%objectType�ж�ʲôԪ�����ϣ��������1
        if solution(1)==0
            fix_t=exprnd(e_manual,1,1);
            manual=manual+1;%����һ������ʱ�䣬����Ҫһ���˹�����
        else
            r=rand(1);
            if r<0.978
                fix_t=exprnd(e_watchdog,1,1);%����ʱ��
            else
                fix_t=exprnd(e_manual,1,1);%�˹�����ʱ��
                manual=manual+1;%����һ������ʱ�䣬����Ҫһ���˹�����?
            end
        end
        newlife=exprnd(e_soft,1,1);
    else  %Ӳ������
        fix_t=exprnd(e_manual,1,1);
        manual=manual+1;%����һ������ʱ�䣬����Ҫһ���˹�����?
        newlife=exprnd(e_hard,1,1);
    end
    if isempty(cur)==1
        cur=[cur;j,t,t+fix_t,t+fix_t+newlife];
    else
        cur=[cur;j,t,cur(size(cur,1),3)+fix_t,cur(size(cur,1),3)+fix_t+newlife];
        %�����ǰһ��������ʱ���У�ʱ��Ҫ��ǰһ�����꿪ʼ��
    end

function b=objectType(j)
    global numOfConnect;
    global solution;
    b=0;%Ӳ��
    if (j>178+numOfConnect*5+53+53)&&(j<=178+numOfConnect*5+53+53+5)&&solution(3)==1 
        b=1;
    elseif (j>19+53*3+numOfConnect*4+53)&&(j<=19+53*3+numOfConnect*4+53+4)&&solution(3)==0
        %���(����)ͷ��master
        b=1;
    end
function eS=errSingle(j)
    global numOfConnect;
    global solution;
    global major
    if j<=19%����������
        b=1;
        major=major+[1,0,0];
    elseif j<=19+53*3%slave����Ӳ��34
        jtmp=j-19;
        b=ceil(jtmp/53)+1;
    elseif j<=19+53*3+numOfConnect*3%slave�ӿڵ�·��
        jtmp=j-(19+53*3);
        if solution(2)==0
            r=rand(1);
            if r<0.42
                b=1;
                major=major+[1,0,0];
            else
                b=ceil(jtmp/numOfConnect)+1;
            end
        else
            b=ceil(jtmp/numOfConnect)+1;
        end
    elseif j<=19+53*3+numOfConnect*3+53%master1����Ӳ����
        if solution(3)==0%û��˫���ȱ�
            b=1;
            major=major+[0,1,0];
        else
            b=5;
        end
    elseif j<=19+53*3+numOfConnect*4+53%master1�ӿڵ�·��
        if solution(2)==0
            r=rand(1);
            if r<0.42
                b=1;
                major=major+[1,0,0];
            else
                b=5;
            end
        else
            b=5;
        end
        if solution(3)==0%û��˫���ȱ���
            b=1;
            major=major+[0,1,0];
        end
    elseif (j<=178+numOfConnect*4+53+53)&&solution(3)==1%%master2����Ӳ��
        b=6;
    elseif (j<=178+numOfConnect*5+53+53)&&solution(3)==1%%master2�ӿڵ�·
        if solution(2)==0
            r=rand(1);
            if r<0.42
                b=1;
                major=major+[1,0,0];
            else
                b=6;
            end
        else
            b=6;
        end
    elseif (j<=178+numOfConnect*5+53+53+5)&&solution(3)==1 %�����˫��?
        jtmp=j-(178+numOfConnect*5+53+53);
        if jtmp==1%master1�������
            b=5;
        elseif jtmp==2
            b=6;
        else
            b=jtmp;%����234����slave
        end
    elseif (j<=19+53*3+numOfConnect*4+53+4)&&solution(3)==0%���������ͷ��master
        jtmp=j-(178+numOfConnect*4+53);
        if jtmp==1%master�������
            b=1;
            major=major+[0,1,0];
        else
            b=jtmp;%����234ȥ����slave
        end
    end
    eS=b;
