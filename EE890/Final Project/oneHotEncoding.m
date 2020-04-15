function [x] = oneHotEncoding(labels)
[i,j]=size(labels);
x=zeros(i,10);
for m=1:i
    p=labels(m,1);
    if (p==0)
        x(m,10)=1;
    else
        x(m,p)=1;
    end
end
end

