clear;
clc;
iteration=50000;
LR=0.13;
input_layer=784;
hidden_layer=25;
output_layer=10;
N=5000;
error=0;
Train_ErrorClass=[1 2 3 4 5 6 7 8 9 0];
Test_ErrorClass=[1 2 3 4 5 6 7 8 9 0];
Train_ErrorClassCount=zeros(1,10);
Test_ErrorClassCount=zeros(1,10);
load digits.mat
for k = 1:5000
dummy = train(:,k) ;
for i = 1:28
for j = 1:28
%x(i,j,k) = double(dummy((i-1)*28 + j)) ;
end
end
% imagesc(x(:,:,k)')
% colormap('gray')
% colorbar
% pbaspect([1 1 1])
% pause(5.0)
end

train_T=double(train');
test_T=double(test');

[q,e]=size(train_T);
Train_Normalized_Features=train_T/255;
Train_Normalized_Features=[ones(q,1) Train_Normalized_Features];
Train_Normalized_Features=Train_Normalized_Features';
train_label=oneHotEncoding(trainlabels);
Test_Normalized_Features=test_T/255 ;
[q,e]=size(test_T);
Test_Normalized_Features=[ones(q,1) Test_Normalized_Features];
Test_Normalized_Features=Test_Normalized_Features';
test_label=oneHotEncoding(testlabels);
W1=weightInitialization(hidden_layer,input_layer+1);
W2=weightInitialization(output_layer,hidden_layer+1);
%%====================TRAINING==================================%%
cost=double(zeros(iteration,1));
for iter=1:iteration
    Z2=W1*Train_Normalized_Features;
    A2=sigmoid(Z2);
    A2=[ones(1,N); A2];
    Z3=W2*A2;
    A3=sigmoid(Z3);
    prediction=A3';
    cost(iter)=costCalc(N, train_label,prediction);
    delta_3=delta_3_calc(N, prediction, train_label,Z3);
    delta_2=delta_2_calc(W2, delta_3, Z2);
    big_delta_1=Train_Normalized_Features*delta_2;
    big_delta_1=big_delta_1./N;
    W1_grad=big_delta_1';
    big_delta_2=A2*delta_3;
    big_delta_2=big_delta_2./N;
    W2_grad=big_delta_2';
    W1=W1+(LR.*W1_grad);
    W2=W2+(LR.*W2_grad);
    
end
plot(1:iteration,cost);
%%%=========================TESTING=====================================%%%
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
%%%======================================================================%%%

