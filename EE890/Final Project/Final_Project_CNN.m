clear;
clc;
load digits.mat
train_y=oneHotEncoding(trainlabels)';
test_y=oneHotEncoding(testlabels)';
train_x = double(reshape(train,28,28,[]))/255;
test_x = double(reshape(test,28,28,[]))/255;
%% setup a convolutional neural network
% input (map size: 28x28)
%   --> convolution with 16 kernels of size 5x5 + sigmoid (24x24x6)
%   --> subsampling with 2x2 kernel (12x12x16)
%   --> convolution with 32 kernels of size 5x5x16 + sigmoid (8x8x32)
%   --> subsampling with 2x2 kernel (4x4x32) + vectorization (512x1)
%   --> fully connection + sigmoid => fully connected (128x1)
%   --> fully connection + sigmoid => output (10x1)
cnn.layers = {
    %input layer
    struct('type', 'input') 
    
    %convolution layer
    struct('type', 'convolution', 'outputmaps', 16, 'kernelsize', 5) 
    
    %subsampling layer (average pooling)
    struct('type', 'mean-pool', 'scale', 2) 
    
    %convolution layer
    struct('type', 'convolution', 'outputmaps', 32, 'kernelsize', 5) 
    
    %subsampling layer (average pooling)
    struct('type', 'mean-pool', 'scale', 2) 
};
cnn = cnnsetup(cnn, train_x, train_y);

%% train the CNN
iterations=2;
for iter=1:iterations
if mod(iter,2)==0
    
learning_rate = 1; 

batch_size = 100; 

num_epochs = 100; 

opts.alpha = learning_rate;
opts.batchsize = batch_size;
opts.numepochs = num_epochs;

% use the classical gradient descent in backpropagation
cnn = cnntrain(cnn, train_x, train_y, opts);

%% test the CNN
[error_rate, cnn, bad] = cnntest(cnn, test_x, test_y);
fprintf('Error rate = %.2f%%\n', error_rate*100);
else
    
learning_rate = 0.4; 

batch_size = 5000; 

num_epochs = 10; 

opts.alpha = learning_rate;
opts.batchsize = batch_size;
opts.numepochs = num_epochs;

% use the classical gradient descent in backpropagation
cnn = cnntrain(cnn, train_x, train_y, opts);

%% test the CNN
[error_rate, cnn, bad] = cnntest(cnn, test_x, test_y);
fprintf('Error rate = %.2f%%\n', error_rate*100);
end
end
