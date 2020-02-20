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
global manual;%人工修理次数
global major;%重大故障原因记录
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
    test_points=[1,2,8,20,100,1000,365*24,365*5*24,10*365*24];%测试点
    test_ava=ones(1,9);
%随机寿命
hard_rand=exprnd(e_hard,1,(53+numOfConnect)*(4+solution(3))+19); %划分
soft_rand=exprnd(e_soft,1,4+solution(3));
global rand_all;
rand_all=[hard_rand,soft_rand];
while t<3650*24
    t=min(rand_all);
    if t>87600
        break;
    end
    j=find(rand_all==t);
    tType=1;%初始化的时间是故障开始
    [cur,cur_num]=makeQueue(j,t);
    if cur(size(cur,1),3)<87600
        last_normal=cur(size(cur,1),3);%最后一个故障被修好
    else %超时则不要这段
        test_ava(9)=0;
        break;%跳出外while
    end
    errs=zeros(1,2);
    errs(1,2)=t;
    errs(1,1)=errType(t,cur);
while isempty(cur)==0%队列不空的时候?
    eT=errType(t,cur);
    tType=getType(t,cur);
    if t~=errs(1,2)&&eT~=errs(size(errs,1),1)%不是第一个，且与上一个错误不同?
        errs=[errs;eT,t];
    end
    if tType==2%故障结束，这个时刻有东西修理完成
        rand_all(cur(1,1))=cur(1,4);   %更新器件时间
%          manual=manual+1;
        cur(1,:)=[];        %出队
        cur_num=cur_num-1;
    end
    if isempty(cur)==0
        t=nextTime(t,cur);%到下一个时刻?
    end

end
%通过errs计算各项指标
errors_normal=errors_normal+1;   %故障次数
errors_major=errors_major+sum(find(errs(:,1)==1));      %重大故障次数
errtime_normal=errtime_normal+(errs(size(errs,1),2)-errs(1,2));%故障时间
for i=1:size(errs,1)-1%重大故障时间
    if errs(i,1)==1
        errtime_major=errtime_major+(errs(i+1,2)-errs(i,2));
    end
 end
if errs(size(errs,1)-1,1)==1
    last_major=last_normal;
end
%可用性测试
ava_i=find(errs(size(errs,1),2)>=test_points&test_points>=errs(1,2));
for ai=ava_i
    test_ava(ai)=0;%不可用 归零
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
    [~,tType]=find(tmp==t);     %第二格是状态1，第三格是状态2
function tnext=nextTime(t,cur)
    tmp=[cur(:,3),cur(:,2)];
    reshape(tmp,1,2*size(tmp,1));
    tnext=tmp(find(tmp>t,1));
function eT=errType(t,cur)
    global major;
    [row,~]=find(cur(:,2:3)==t);
    j=cur(row,1);%找到当前t的j
    %生成影响向量
    influence=0;
    influence(1)=[];
    for i=1:size(cur,1)
        if cur(i,3)>t &&cur(i,2)<=t
            influence=[influence,cur(i,1)];%影响对象
        end
    end
    if isempty(influence)==1%若没有影响对象，意味着到了当前队列最后一个元件修理完成
        eT=0;
        return
    end
    %生成单个影响因子的错误类型
    eS=0;
    eS(1)=[];
    for k=1:size(influence,2)
        eS=[eS,errSingle(influence(k))];
    end
    %分析是否出现重大故障
    if find(eS==1)
        eT=1;
        return
    else
        if size(eS,2)==1
            eT=eS;
            return
        end
        tmp=eS(1);
        if tmp<=4       %从机故障
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
%A修复完时间A2
%这段时间内有故障的话入队，生成新的修复时间，直到完成为止
global rand_all;
cur=zeros(1,4);
cur(1,:)=[];
cur=enqueue(j,t,cur);%第一个对象入队?
cur_num=1;
i=1;
while true
    t_fixup=cur(size(cur,1),3);
    fixing=find(rand_all>t&rand_all<=t_fixup);%当前最后对象修好之前坏掉的新对象索引j向量
    if isempty(fixing)==1
        break;
    end
%     t=cur(i,3);i=i+1;%时间拨到第i个修好
    t=t_fixup;  %时间起点切到上一次时间终点
    while isempty(fixing)==0
        cur=enqueue(fixing(1),rand_all(fixing(1)),cur);
        cur_num=cur_num+1;
        fixing(1)=[];%第一个出队（fixing队列
    end
end

function cur=enqueue(j,t,cur)
    e_hard=125000;e_soft=4900;e_manual=10;e_watchdog=1;
    global solution;
    global manual;
    if objectType(j)==1%objectType判断什么元件故障，软件故障1
        if solution(1)==0
            fix_t=exprnd(e_manual,1,1);
            manual=manual+1;%生成一次修理时间，就需要一次人工修理
        else
            r=rand(1);
            if r<0.978
                fix_t=exprnd(e_watchdog,1,1);%重启时间
            else
                fix_t=exprnd(e_manual,1,1);%人工修理时间
                manual=manual+1;%生成一次修理时间，就需要一次人工修理?
            end
        end
        newlife=exprnd(e_soft,1,1);
    else  %硬件故障
        fix_t=exprnd(e_manual,1,1);
        manual=manual+1;%生成一次修理时间，就需要一次人工修理?
        newlife=exprnd(e_hard,1,1);
    end
    if isempty(cur)==1
        cur=[cur;j,t,t+fix_t,t+fix_t+newlife];
    else
        cur=[cur;j,t,cur(size(cur,1),3)+fix_t,cur(size(cur,1),3)+fix_t+newlife];
        %如果在前一个的修理时间中，时间要从前一个修完开始算
    end

function b=objectType(j)
    global numOfConnect;
    global solution;
    b=0;%硬件
    if (j>178+numOfConnect*5+53+53)&&(j<=178+numOfConnect*5+53+53+5)&&solution(3)==1 
        b=1;
    elseif (j>19+53*3+numOfConnect*4+53)&&(j<=19+53*3+numOfConnect*4+53+4)&&solution(3)==0
        %软件(单机)头是master
        b=1;
    end
function eS=errSingle(j)
    global numOfConnect;
    global solution;
    global major
    if j<=19%集线器错误
        b=1;
        major=major+[1,0,0];
    elseif j<=19+53*3%slave控制硬部34
        jtmp=j-19;
        b=ceil(jtmp/53)+1;
    elseif j<=19+53*3+numOfConnect*3%slave接口电路板
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
    elseif j<=19+53*3+numOfConnect*3+53%master1控制硬部件
        if solution(3)==0%没有双机热备
            b=1;
            major=major+[0,1,0];
        else
            b=5;
        end
    elseif j<=19+53*3+numOfConnect*4+53%master1接口电路板
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
        if solution(3)==0%没有双机热备
            b=1;
            major=major+[0,1,0];
        end
    elseif (j<=178+numOfConnect*4+53+53)&&solution(3)==1%%master2控制硬件
        b=6;
    elseif (j<=178+numOfConnect*5+53+53)&&solution(3)==1%%master2接口电路
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
    elseif (j<=178+numOfConnect*5+53+53+5)&&solution(3)==1 %软件（双机?
        jtmp=j-(178+numOfConnect*5+53+53);
        if jtmp==1%master1的软件坏
            b=5;
        elseif jtmp==2
            b=6;
        else
            b=jtmp;%故障234区分slave
        end
    elseif (j<=19+53*3+numOfConnect*4+53+4)&&solution(3)==0%软件（单机头是master
        jtmp=j-(178+numOfConnect*4+53);
        if jtmp==1%master的软件坏
            b=1;
            major=major+[0,1,0];
        else
            b=jtmp;%故障234去区分slave
        end
    end
    eS=b;
