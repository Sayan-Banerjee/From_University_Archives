clear All;
clc;
I=double(imread('newCross.png'));
%    for i=1:12
%        for j=1:12
%            if (I(i,j)==1.0)
%                I(i,j)=0.75;
%            end
%                
%        end
%    
%    end

V_th=double(5.*ones(12,12));
Record_Keeping = double(zeros(144,2001));
tau=12.0;
meu=1.0;
h0=0.08;
beta=0.25;
V0=5.0;
E=4.8;
deltaVm=double(zeros(12,12));
S=double(zeros(12,12));
P=double(zeros(12,12));
Spike_Count=zeros(144,1);
for t=1:2001
    for i=1:12
        for j=1:12
            if (I(i,j)>0)
            P(i,j)=neighbor_contribution(Record_Keeping, i,j, t, Spike_Count,h0,tau);
            S(i,j)=I(i,j)*(1+beta*(P(i,j)));
            V_th(i,j)=V0-S(i,j);
            relative_t=double(time_passed_since_previous_spike(Record_Keeping, i, j, t));
            deltaVm(i,j)=E*(1-exp(-relative_t/meu));
            if (deltaVm(i,j)>=V_th(i,j))
                pos=Position(i,j);
                Spike_Count(pos,1)=Spike_Count(pos,1)+1;
                time=time_passed_since_previous_spike(Record_Keeping, i, j, t);
                Record_Keeping(pos,t)=time;
                
            end
            end
        end
    end

end
Interval=zeros(1,201);


 for b=1:144
     for a=1:2001
             if Record_Keeping(b,a)~=0
				  spke=int32(Record_Keeping(b,a)*10);
                 Interval(1,spke)=Interval(1,spke)+1; 
                 
                 
            end
     end
     
 end
 axis=[0.1:2.0:0.1];
 
 figure
 %histogram(Interval)
 bar(axis, Interval(1:20));