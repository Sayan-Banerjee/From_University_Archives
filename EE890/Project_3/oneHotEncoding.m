function [x]=oneHotEncoding(labels,d)
x= zeros(size(labels));
[q,e]=size(labels);
for i=1:q
    if (labels(i,1)==d)
        x(i,1)=1;
    else
        x(i,1)=-1; 
    end
end

end
