function [x] = normalized(M,Train_mean,Train_std)
[q,e]=size(M);
x= zeros(q,e);
for i= 1: e
    for j = 1:q
        x(j,i)=(M(j,i)-Train_mean(1,i));
        if Train_std(1,i) > 0.0
            x(j,i)=x(j,i)/Train_std(1,i);
        end
    end
end

end
