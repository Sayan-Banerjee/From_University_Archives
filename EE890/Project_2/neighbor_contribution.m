function [p]=neighbor_contribution(Record_Keeping, i,j, t, Spike_Count,h0,tau)
p=0;
z=0;
%neighbor 1
pos=Position(i-1,j-1);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
%neighbor 2
pos=Position(i-1,j);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
%neighbor 3
pos=Position(i-1,j+1);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
%neighbor 4
pos=Position(i,j-1);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
%neighbor 5
pos=Position(i,j+1);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
%neighbor 6
pos=Position(i+1,j-1);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
%neighbor 7
pos=Position(i+1,j);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
%neighbor 8
pos=Position(i+1,j+1);
x=Spike_Count(pos,1);
t_1=t;
while x>0
    if(Record_Keeping(pos,t_1)>0)
        y=(t-t_1)*0.1;
        z=z+h0*exp(-y/tau);
        x=x-1;
    end
    t_1=t_1-1;
end
p=z;

end
