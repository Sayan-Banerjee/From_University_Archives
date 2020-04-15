function w = negentropy(x, w)
  tmp1 = zeros(size(x));
  tmp2 = zeros(1, size(x, 2));
  for j = 1:size(x, 2)
      tmp1(:,j) = x(:,j)*g1((w'*x(:,j)));
      tmp2(:,j) = g1d(w'*x(:,j));
  end
  w = mean(tmp1,2) - mean(tmp2,2)*w;
end
