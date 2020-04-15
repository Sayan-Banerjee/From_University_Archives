clear;
clc;
d=2;
ILR=10.0;
TAU=2500.0;
error=0;
Train_ErrorClass=[1 2 3 4 5 6 7 8 9 0];
Test_ErrorClass=[1 2 3 4 5 6 7 8 9 0];
Train_ErrorClassCount=zeros(1,10);
Test_ErrorClassCount=zeros(1,10);
TruePositive=0;
TrueNegative=0;
FalsePositive=0;
FalseNegative=0;
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
Train_Normalized_Features=train_T;
Train_Normalized_Features=[ones(q,1) Train_Normalized_Features];
train_label=oneHotEncoding(trainlabels,d);
Test_Normalized_Features=test_T;
[q,e]=size(test_T);
Test_Normalized_Features=[ones(q,1) Test_Normalized_Features];
test_label=oneHotEncoding(testlabels,d);
%=========================================================================================================
%======================TRAINING=======================

[q,e]=size(Train_Normalized_Features);
W=zeros(1,e);
for i=1:q
    value=Train_Normalized_Features(i,:)*W';
    if value > 0
        v=1;
    else
        v=-1;
    
    end
    
    if train_label(i,1)~=v && i>4900
       error=error+1;
       disp ('==============*****************===============');
       disp('ERROR');
       disp(error);
       disp('ITERATION');
       disp(i);
       disp('ORIGINAL LABEL');
       disp (trainlabels(i,1));
       disp ('==============*****************===============');
       msdcls=trainlabels(i,1);
       if msdcls==0
           Train_ErrorClassCount(1,10)=Train_ErrorClassCount(1,10)+1;
       else
           Train_ErrorClassCount(1,msdcls)= Train_ErrorClassCount(1,msdcls)+1;
       end
    end
    
    if train_label(i,1)~=v && v==1
         LR= ILR/(1+(i/TAU));
         W=W-LR*(Train_Normalized_Features(i,:));
         %LR = 0.0;  
    end
    
    if train_label(i,1)~=v && v==-1
        
        LR= double(ILR/(1.0+double((i/TAU))));
        disp(LR);
        W=W+LR*(Train_Normalized_Features(i,:));
        %LR = 0.0;  
    end

end
disp(LR);
%=========================================================================================================
%======================TESTING=======================
disp('**************TESTING**************');
total_error=0;
[q,e]=size(Test_Normalized_Features);

for i=1:q
    value=0.0;
    v=0;
    value=Test_Normalized_Features(i,:)*W';
    if value >= 0
        v=1;
    else
        v=-1;
    
    end
    
    if test_label(i,1)~=v
       total_error=total_error+1;
       if v==1
          FalsePositive=FalsePositive+1; 
       end
       if v==-1
           FalseNegative=FalseNegative+1;
       end
       disp ('==============*****************===============');
       disp('ERROR');
       disp(total_error);
       disp('ITERATION');
       disp(i);
       disp('ORIGINAL LABEL');
       disp (testlabels(i,1));
       disp ('==============*****************===============');
       msdcls=testlabels(i,1);
       if msdcls==0
           Test_ErrorClassCount(1,10)=Test_ErrorClassCount(1,10)+1;
       else
           Test_ErrorClassCount(1,msdcls)= Test_ErrorClassCount(1,msdcls)+1;
       end
       else
        if v==1
            TruePositive=TruePositive+1;
        end
        if v==-1
            TrueNegative=TrueNegative+1;
        end
    end
    
end
disp('**************ACCURACY**************');
accuracy=((q-total_error)/q)*100;
disp (accuracy);
disp('**************PRECISION**************');
precision=TruePositive/(TruePositive+FalsePositive);
disp(precision);
disp('**************RECALL**************');
recall=TruePositive/(TruePositive+FalseNegative);
disp(recall);
Weights=W(1,2:785);
%Weights=(Train_std.*(Weights))+Train_mean;
W_D=reshape(Weights,28,28);
imshow(W_D);
%imagesc(W_D)
colormap('gray')
colorbar
pbaspect([1 1 1])

disp('******TRAINING MISSED CLASSES IN LAST 100 ITERATIONS*******');
disp(Train_ErrorClass);
disp(Train_ErrorClassCount);
disp('**************TESTING MISSED CLASSES**************');
disp(Test_ErrorClass);
disp(Test_ErrorClassCount);
