clear;
clc;
load digits.mat
X=double(zeros(5000,28,28));
for k = 1:5000
dummy = train(:,k) ;
X(k,:,:)=reshape(dummy,28,28);
end
X_test=double(zeros(1000,28,28));
for k = 1:1000
dummy = test(:,k) ;
X_test(k,:,:)=reshape(dummy,28,28);
end
X=X/255;
X_test=X_test/255;
Y=oneHotEncoding(trainlabels);
filter1_R=5;
filter1_C=5;
filter1_N=16;
bias1=double(zeros(filter1_N,1));
for i=1:filter1_N
    filter1(:,:,i)=Filter1Initialization(filter1_R, filter1_C);
end
filter2_R=3;
filter2_C=3;
filter2_D=16;
filter2_N=32;
for i=1:filter2_N
    filter2(:,:,:,i)=Filter3DInitialization(filter2_R, filter2_C,filter2_D);
end
bias2=double(zeros(filter2_N,1));

filter3_R=2;
filter3_C=2;
filter3_D=32;
filter3_N=64;
for i=1:filter3_N
    filter3(:,:,:,i)=Filter3DInitialization(filter3_R, filter3_C,filter3_D);
end
bias3=double(zeros(filter3_N,1));
fc_w4_R=128;
fc_w4_C=1025;
fc_w4=WeightInitialization(fc_w4_R,fc_w4_C);
fc_w5_R=32;
fc_w5_C=129;
fc_w5=WeightInitialization(fc_w5_R,fc_w5_C);
fc_w6_R=10;
fc_w6_C=33;
fc_w6=WeightInitialization(fc_w6_R,fc_w6_C);
LR=0.1;
%===============Forward Propagation===================
for FP=1:10
for sgd=1:100:5000
X_train=X(sgd:sgd+99,:,:);
Y_train=Y(sgd:sgd+99,:);
N=100;
iteration=100;
cost=double(zeros(iteration,1));
for iter=1:iteration
%===============1st Convolution Layer=======================
    for i=1:filter1_N
        filter=reshape(filter1(:,:,i),1,25);
        for j=1:N
            for p=1:24
                for q=1:24
                 input=reshape(X_train(j,p:p+filter1_R-1,q:q+filter1_C-1),1,25);
                 z2(j,p,q,i)=dot(filter,input);
                 z2(j,p,q,i)=z2(j,p,q,i)+bias1(i,1);
                end
            end
        end
    end
    a2=sigmoid(z2);
    %===================1st Mean Pooling=========================
    for i=1:filter1_N
        for j=1:N
            p_x=1;

            for p=1:2:23
                p_y=1;
                for q=1:2:23
                    s=(a2(j,p,q,i)+a2(j,p+1,q,i)+a2(j,p,q+1,i)+a2(j,p+1,q+1,i))/4.0;
                    a_p2(j,p_x,p_y,i)=s;
                    p_y=p_y+1;
                end
                p_x=p_x+1;
            end
        end
    end
    %====================2nd Convolution========================
    for i=1:filter2_N
        filter=double(zeros(1,144));
        filter=reshape(filter2(:,:,:,i),1,144);
        for j=1:N
            for p=1:10
                for q=1:10
                    input=double(zeros(1,144));
                    input=reshape(a_p2(j,p:p+filter2_R-1,q:q+filter2_C-1,:),1,144);
                    z3(j,p,q,i)=dot(filter,input);
                    z3(j,p,q,i)=z3(j,p,q,i)+bias2(i,1);
                end
            end
        end
    end
    a3=sigmoid(z3);
    %==========================2nd Mean Pool============================
    for i=1:filter2_N
        for j=1:N
            p_x=1;

            for p=1:2:9
                p_y=1;
                for q=1:2:9
                    s=(a3(j,p,q,i)+a3(j,p+1,q,i)+a3(j,p,q+1,i)+a3(j,p+1,q+1,i))/4.0;
                    a_p3(j,p_x,p_y,i)=s;
                    p_y=p_y+1;
                end
                p_x=p_x+1;
            end
        end
    end
    %=========================3rd Convolution Layer========================
    for i=1:filter3_N
        filter=double(zeros(1,128));
        filter=reshape(filter3(:,:,:,i),1,128);
        for j=1:N
            for p=1:4
                for q=1:4
                    input=double(zeros(1,128));
                    input=reshape(a_p3(j,p:p+filter3_R-1,q:q+filter3_C-1,:),1,128);
                    z4(j,p,q,i)=dot(filter,input);
                    z4(j,p,q,i)=z4(j,p,q,i)+bias3(i,1);
                end
            end
        end
    end
    %========================FLATTEN=========================================
    for i=1:N
        fc=reshape(z4(i,:,:,:),1024,1);
        fc_z4(:,i)=fc;
    end
    %=========================FULLY CONNECTED=================================
    fc_a4=sigmoid(fc_z4);
    fc_a4_b=[ones(1,N);fc_a4];
    fc_z5=fc_w4*fc_a4_b;
    fc_a5=sigmoid(fc_z5);
    fc_a5_b=[ones(1,N);fc_a5];
    fc_z6=fc_w5*fc_a5_b;
    fc_a6=sigmoid(fc_z6);
    fc_a6_b=[ones(1,N);fc_a6];
    fc_z7=fc_w6*fc_a6_b;
    fc_a7=sigmoid(fc_z7);
    prediction=fc_a7';
    cost(iter)=costCalc(N, Y_train,prediction);
    delta7=delta_7_calc(prediction, Y_train);
    delta6=fc_delta_Calc(fc_w6,delta7,fc_z6);
    delta5=fc_delta_Calc(fc_w5,delta6,fc_z5);
    delta4=fc_delta_Calc(fc_w4,delta5,fc_z4);
    delta4_T=delta4';
    %==================FLATTEN to Conv.=======================
    for i=1:N
        cnv=reshape(delta4_T(:,i),1,4,4,64);
        c_delta4(i,:,:,:)=cnv;
    end
    %=============Convolution Delta Calculation Layer 3=============
    for i=1:N
        for j=1:filter3_D
           for x=1:5
               for y=1:5
                   weight=reshape(filter3(:,:,j,:),2,2,64);
                   curr_delta=reshape(c_delta4(i,:,:,:),4,4,64);
                   value=0.0;
                   for r=1:64
                       for p=1:4
                           for q=1:4
                               if (x-p+1)>0 && (x-p+1)<3 && (y-q+1)> 0 && (y-q+1)<3
                                   flag=1;
                               else 
                                   flag=0;
                               end
                               if flag==1
                                   value=value+(curr_delta(p,q,r)*weight(x-p+1,y-q+1,r));
                               end
                           end
                       end
                   end
                   c_p_delta3(i,x,y,j)=value;
               end
           end
        end
    end
    c_delta3=double(zeros(N,10,10,filter2_N));
    for i=1:N
        for l=1:filter2_N
            for j=1:10
                for k=1:10
                    x=int32(ceil(j/2));
                    y=int32(ceil(k/2));
                    c_delta3(i,j,k,l)= c_p_delta3(i,x,y,l)/4;
                end
            end
        end
    end
    
    sigmdG=sigmoidGradient(z3);
    c_delta3=c_delta3.*sigmdG;
    
  %=============Convolution Delta Calculation Layer 2=============
  for i=1:N
        for j=1:filter2_D
           for x=1:12
               for y=1:12
                   weight=reshape(filter2(:,:,j,:),3,3,32);
                   curr_delta=reshape(c_delta3(i,:,:,:),10,10,32);
                   value=0.0;
                   for r=1:32
                       for p=1:10
                           for q=1:10
                               if (x-p+1)>0 && (x-p+1)<4 && (y-q+1)> 0 && (y-q+1)<4
                                   flag=1;
                               else 
                                   flag=0;
                               end
                               if flag==1
                                   value=value+(curr_delta(p,q,r)*weight(x-p+1,y-q+1,r));
                               end
                           end
                       end
                   end
                   c_p_delta2(i,x,y,j)=value;
               end
           end
        end
   end
    c_delta2=double(zeros(N,24,24,filter1_N));
    for i=1:N
        for l=1:filter1_N
            for j=1:24
                for k=1:24
                    x=int32(ceil(j/2));
                    y=int32(ceil(k/2));
                    c_delta2(i,j,k,l)= c_p_delta2(i,x,y,l)/4;
                end
            end
        end
    end
    
    sigmdG2=sigmoidGradient(z2);
    c_delta2=c_delta2.*sigmdG2;
    %============================Gradient Calculation for all Weights===============================================
    for i=1:filter1_N
        filter=reshape(c_delta2(:,:,:,i),1,N*576);
            for p=1:5
                for q=1:5
                 input=reshape(X_train(:,p:p+24-1,q:q+24-1),1,N*576);
                 big_delta1(p,q,i)=dot(filter,input);
                 
                end
            end
    end
    big_delta1=big_delta1./N;
    
    clear filter p q input i;
    
    for i= 1:filter2_N
        filter=reshape(c_delta3(:,:,:,i),1,N*100);
        for j=1:filter2_D
            for p=1:3
                for q=1:3
                    input=reshape(a_p2(:,p:p+10-1,q:q+10-1,j), 1,N*100);
                    big_delta2(p,q,j,i)=dot(filter,input);
                                        
                end
            end
        end
    end
    big_delta2=big_delta2./N;
    clear filter p q input i j;
    for i= 1:filter3_N
        filter=reshape(c_delta4(:,:,:,i),1,N*16);
        for j=1:filter3_D
            for p=1:2
                for q=1:2
                    input=reshape(a_p3(:,p:p+4-1,q:q+4-1,j), 1,N*16);
                    big_delta3(p,q,j,i)=dot(filter,input);
                                        
                end
            end
        end
    end
    big_delta3=big_delta3./N;
    
    clear filter p q input i;
    
   fc_big_delta4=fc_a4_b*delta5;
   fc_big_delta4=fc_big_delta4./N;
   fc_big_delta5=fc_a5_b*delta6;
   fc_big_delta5=fc_big_delta5./N;
   fc_big_delta6=fc_a6_b*delta7;
   fc_big_delta6=fc_big_delta6./N;
   fc_w4_grad=fc_big_delta4';
   fc_w5_grad=fc_big_delta5';
   fc_w6_grad=fc_big_delta6';
   bias1_grad=double(zeros(filter1_N,1));
   for i=1: filter1_N
       
       value=reshape(c_delta2(:,:,:,i),N*576,1);
       bias1_grad(i,1)=sum(value);
       
   end
   bias1_grad=bias1_grad./N;
   clear value i;
   bias2_grad=double(zeros(filter2_N,1));
   for i=1: filter2_N
       
       value=reshape(c_delta3(:,:,:,i),N*100,1);
       bias2_grad(i,1)=sum(value);
       
   end
   bias2_grad=bias2_grad./N;
   clear value i;
   bias3_grad=double(zeros(filter3_N,1));
   for i=1: filter3_N
       
       value=reshape(c_delta4(:,:,:,i),N*16,1);
       bias3_grad(i,1)=sum(value);
       
   end
   bias3_grad=bias3_grad./N;
   
   %===============================Weights Adjustment==================================
   
   filter1=filter1+(LR.*big_delta1);
   filter2=filter2+(LR.*big_delta2);
   filter3=filter3+(LR.*big_delta3);
   fc_w4=fc_w4+(LR.*fc_w4_grad);
   fc_w5=fc_w5+(LR.*fc_w5_grad);
   fc_w6=fc_w6+(LR.*fc_w6_grad);
   bias1=bias1+(LR.*bias1_grad);
   bias2=bias2+(LR.*bias2_grad);
   bias3=bias3+(LR.*bias3_grad);


end
disp('============');
disp(sgd);
disp('-------------------');
disp(cost(iter));
end
end

