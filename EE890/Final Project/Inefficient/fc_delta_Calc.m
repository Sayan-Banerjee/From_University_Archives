function delta=fc_delta_Calc(W, delta_nxt, Z)
sg_g=sigmoidGradient(Z);
W_E=W(:,2:end);
delta=(delta_nxt*W_E).*sg_g';
end