function delta3=delta_3_calc(N, prediction, train_label,Z3)
diff=train_label-prediction;
% sg_g=sigmoidGradient(Z3);
% sg_g_T=sg_g';
% delta3=diff.*sg_g_T;
delta3=diff;
end