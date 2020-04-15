function [relative_time] = time_passed_since_previous_spike(Record_Keeping, i, j, t)
relative_time=0.0;
flag=1.0;
i_1=Position(i,j);
j_1=t;
current=double(j_1);
while j_1>1
    
    if (Record_Keeping(i_1,j_1)>0.0)
        flag=double(j_1);
        break;
    end
    j_1=j_1-1;
end

if t~=1
relative_time=double((current - flag ))*0.1;
end    
end