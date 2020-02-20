clc
lamda1=1/125000;
lamda2=1/4900;
lamda3=1/10;
numOfHard=53;
numOfCombine=19;

solution=[1,1,1];

if solution(2)==1
    numOfConnect=29;
else
    numOfConnect=21;
end

P1_hard=lamda3/(lamda1+lamda3);
P2_hard=0.58*lamda1/(lamda1+lamda3);
P3_hard=0.42*lamda1/(lamda1+lamda3);

if solution(1)==1
    P2_soft=lamda2/(lamda3+lamda2)*0.022;
else 
    P2_soft=lamda2/(lamda3+lamda2);
end
P1_soft=1-P2_soft;

P_connect1=(P1_hard)^numOfConnect;
P_connect2=1-(1-P2_hard)^numOfConnect;
P_connect3=1-P_connect1-P_connect2;

P_tough1=(P1_hard)^numOfHard;
P_tough2=1-P_tough1;

P_combine1=(P1_hard)^numOfCombine;
P_combine2=1-P_combine1;

P_perfect=P1_soft*P_connect1*P_tough1;
if solution(3)==0
    P=P_perfect*P_combine1*P_perfect^3;
else
    P=P_perfect^2*P_combine1^2*P_perfect^3;
end