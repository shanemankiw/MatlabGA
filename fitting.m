%��Ϻ���

function [fittingdata]=fitting(pop,popsize,M,popdata,voltage)


for i=1:M
    for j=1:popsize
        x=popdata(i,j,:);
        y=pop(j,:);
        xx=voltage(i,:);
        pp=spline(x,y);
        %�Ե�ѹΪx���꣬�¶�Ϊy���꣬�Ժ����������
        fittingdata(i,j,:)=ppval(pp,xx);
        %��ֵ���õ��������fittingdata
    end
end
    