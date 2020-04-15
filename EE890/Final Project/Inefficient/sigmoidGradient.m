function g = sigmoidGradient(z)

g = double(zeros(size(z)));

sigm = 1.0 ./ (1.0 + exp(-z));

g = sigm.*(1-sigm);


end
