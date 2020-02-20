%可用性估算

clear
clc

global A;
global pa;
pa=1;
A=zeros(10,1);

lamdaA = 1/77200; %参数初始化
lamdaB = 1/235000;
P_EA = [0.14,0.28,0.58];
P_EB = [0.69,0.31];
w=25000;
k = 4;

%概率初始化
P_A0=exp(-lamdaA*w);
P_A1=P_EA(1)*(1-exp(-lamdaA*w));
P_A2=P_EA(2)*(1-exp(-lamdaA*w));
P_A3=P_EA(3)*(1-exp(-lamdaA*w));

P_B0=exp(-lamdaB*w);
P_B1=P_EB(1)*(1-exp(-lamdaB*w));
P_B2=P_EB(2)*(1-exp(-lamdaB*w));

P_PF=P_A0*P_B0;
P_MO=P_A0*P_B1+P_A2*P_B1;
P_SO=P_A0*P_B2+P_A1*P_B0+P_A1*P_B2;
P_FB=P_A1*P_B1;
P_DM=P_A2*P_B0;
P_DN=P_A2*P_B2+P_A3*(P_B0+P_B1+P_B2);

P_G=[P_PF P_SO P_DM P_MO P_DN P_FB];
right=[];
for n = 4:13

G_N = zeros(n,1); %节点状态向量
Q = zeros(1,6);
C = zeros(1,10);

for i=0:n
    for j=0:n
        if i+j>n
            %i=i+1;
            break;
        end
        for l=0:n
            if i+j+l>n
                continue;
            end
            for o=0:n
                if i+j+l+o>n
                    continue;
                end
                for p=0:n
                    if i+j+l+o+p>n
                        continue;
                    end
                    for q=0:n
                        if i+j+l+o+p+q~=n
                            continue;
                        else
                            Q(:)=[i j l o p q];
                            C = condition(Q,k);         %计算
                            [Gsys,err] = system_state(C);%得到当前的系统状态
                            if Gsys==3
                                pa=pa*C(10);
                            end
                            if Gsys==2||Gsys==3
                            pa=pa*nchoosek(n,Q(1))*nchoosek(n-Q(1),Q(2)) ...
                            *nchoosek(n-Q(1)-Q(2),Q(3))*nchoosek(n-Q(1)-Q(2)-Q(3),Q(4)) ...
                            *nchoosek(n-Q(1)-Q(2)-Q(3)-Q(4),Q(5))*P_G(1)^Q(1) ...
                            *P_G(2)^Q(2)*P_G(3)^Q(3)*P_G(4)^Q(4) ...
                            *P_G(5)^Q(5)*P_G(6)^Q(6);
                            A(n-3)=A(n-3)+pa;
                            pa=1;
                            end
                        end
                    end
                end
            end
        end
    end
end
end
dlmwrite ('Q.csv',right);
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
end
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
                Gsys = 3;
                if Gsys == 4 %err
                    err(5) = 1;
                end
    end
end

    



            
