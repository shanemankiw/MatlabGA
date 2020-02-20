
function main()
clear
clc
Err = zeros(10,5);
for n = 4:13
lamdaA = 1/77200; %参数初始化
lamdaB = 1/235000;
P_EA = [0.14,0.42,1];
P_EB = [0.69,1];
k = 4;
Nsample = 10000;
life = zeros(1,Nsample);
liferand = zeros(2,n);
errsum = zeros(1,5);

for m = 1:Nsample
    G_A = zeros(n,1); %切换器A状态向量
    G_B = zeros(n,1); %切换器B状态向量
    G_N = zeros(n,1); %节点状态向量
    Q = zeros(1,6);
    C = zeros(1,10);
    err = zeros(1,5);%表示c1,c2,c3,c4,c89
    liferand(1,:) = exprnd(1/lamdaA,1,n);
    liferand(2,:) = exprnd(1/lamdaB,1,n);
    lifesort = reshape(liferand,1,2*n);
    lifesort = sort(lifesort);
    for t = lifesort
        if t>78000
            life(m) = 78000;
            break;
        end
    j = find(liferand==t);
    r = rand(1);
    if mod(j,2)==1  %切换器A状态
        j=ceil(j/2);
        if r <= P_EA(1)
            G_A(j) = 1;
        elseif r <=P_EA(2) && r > P_EA(1)
                G_A(j) = 2;
            else 
                G_A(j) = 3;
        end
    elseif mod(j,2)==0  %切换器B状态
        j = j/2;
        if r <= P_EB(1)
            G_B(j) = 1;
            else 
                G_B(j) = 2;
        end
    end
    G_N = getGN(G_A,G_B);
    %计算Q
    for i = 1:6
        Q(i) = sum(G_N==i);
    end
    C = condition(Q,k);          %计算C
    [Gsys,err] = system_state(C);      %得到当前的系统状态
    if Gsys==1 ||Gsys==4
        life(m)=t;
        errsum = errsum + err;
        break;
    end
    end
end
ave_lifes(n-3) = mean(life);
R(n-3) = sum(life>25000)/size(life,2);
Err(n-3,:) = errsum;
Err2(n-3) = sum(errsum);
end

Err3 = Err;
for a = 1:10
    Err3(a,:) = Err(a,:)/Err2(a);
end
Err=Err'
R
ave_lifes
Err2
Err3
max_n = find(ave_lifes == max(ave_lifes))+3;

fprintf('max_n = %d\n',max_n);
% fprintf('ave_life=%7.2f\n',ave_life);
dlmwrite('Q2Err.csv',Err,'-append');
%计算节点状态
function G_N = getGN(G_A,G_B) 
number = size(G_A,1);
G_N = zeros(number,1);
for i = 1:number
    if G_A(i)==0
        if G_B(i)==0
            G_N(i) = 1;
        end
        if G_B(i)==1
            G_N(i) = 4;
        end
        if G_B(i)==2
            G_N(i) = 2;
        end
    end
    if G_A(i)==1
        if G_B(i)==0
            G_N(i) = 2;
        end
        if G_B(i)==1
            G_N(i) = 6;
        end
        if G_B(i)==2
            G_N(i) = 2;
        end
    end
    if G_A(i)==2
        if G_B(i)==0
            G_N(i) = 3;
        end
        if G_B(i)==1
            G_N(i) = 4;
        end
        if G_B(i)==2
            G_N(i) = 5;
        end
    end
    if G_A(i)==3
        G_N(i) = 5;
    end
end
%计算系统状态
function C = condition(Q,k)
    C = zeros(1,10);
    if Q(6) >= 1
        C(1) = 1;
    end
    if Q(4) >= 2
        C(2) = 1;
    end
    if Q(1)+Q(4)+Q(3) == 0
        C(3) = 1;
    end
    if Q(1)+Q(2)+((Q(3)+Q(4))>0) < k
        C(4) = 1;
    end
    if Q(6) == 0
        C(5) = 1;
    end
    if Q(4) == 1 && Q(1)+Q(2) >= k-1
        C(6) = 1;
    end
    if Q(4) == 0 && Q(1) == 0 && Q(3) >= 1 && Q(2) >= k-1
        C(7) = 1;
    end
    if Q(4) == 0 && Q(1) >=1 && Q(1)+Q(2)>=k
        C(7) = 1;
    end
    if Q(6)+Q(4) == 0
        C(8) = 1;
    end
    if Q(1) >=1 && Q(1)+Q(2) ==k-1 && Q(3) >= 1
        C(9) = 1;
    end
    C(10) = Q(3)/(Q(1)+Q(3));%Gsys 3小于这个概率能工作
function [Gsys,err] = system_state(C)
    err = zeros(1,5);
    for i = 1:4%err
        if C(i) == 1
            err(i) = 1;
            Gsys = 1;
        end
    end
    if C(5) == 1 && C(6)+C(7) >= 1
            Gsys = 2;
    elseif C(8)+C(9) == 2
                Gsys = 4-(rand(1)<C(10));
                if Gsys == 4 %err
                    err(5) = 1;
                end
    end
    
