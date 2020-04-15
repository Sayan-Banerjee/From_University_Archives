function J = costCalc(N,actual_label,prediction)
cost = (-actual_label.*log(prediction))-((1-actual_label).*log(1-prediction));
J= sum(cost(:));
J =J/N;
end