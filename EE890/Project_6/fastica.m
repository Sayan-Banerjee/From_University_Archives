function W = fastica(x)
  W = rand(size(x,1), size(x,1));
  lw = zeros(size(W,1),1);
  p = 0;
  while 1
    W(:,p+1) = negentropy(x,W(:,p+1));
    
    wsum = zeros(size(W,1),1);
     if p >= 1
         for j = 1:p
            wsum = wsum + W(:,p+1)'*W(:,j)*W(:,j);
         end
         W(:,p+1) = W(:,p+1) - wsum;
     end
    W(:,p+1) = W(:,p+1) / norm(W(:,p+1));
    if (1 - abs(dot(W(:,p+1), lw))) < 0.000000000001
        p = p+1;
        if p+1 > size(W,2)
            break;
        end
    else
      lw = W(:,p+1);
    end
  end
end
