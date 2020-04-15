clear;
clc;
load('Weights');
T_N=1000;
T_Z2=W1*Test_Normalized_Features;
T_A2=sigmoid(T_Z2);
T_A2=[ones(1,T_N); T_A2];
T_Z3=W2*T_A2;
T_A3=sigmoid(T_Z3);
T_prediction=T_A3';
[dummy, p] = max(T_prediction, [], 2);
for i=1:T_N
    if p(i,1)==10
        p(i,1)=0;
    end
    if double(p(i,1))~=double(testlabels(i,1))
        error=error+1;
        if testlabels(i,1)==0
            Test_ErrorClassCount(1,10)=Test_ErrorClassCount(1,10)+1;
        else
            y=testlabels(i,1);
            Test_ErrorClassCount(1,y)=Test_ErrorClassCount(1,y)+1;
        end
    end
    
        
end
accuracy=((1000-error)/1000)*100;
disp(accuracy);
disp(Test_ErrorClass);
disp(Test_ErrorClassCount);