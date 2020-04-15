function delta2=delta_2_calc(W2, delta_3, Z2)
sg_g=sigmoidGradient(Z2);
W=W2(:,2:end);
delta2=(delta_3*W).*sg_g';
end