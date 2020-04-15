function [] = Plot(cnn)
figure('numberTitle', 'off', 'name', ...
    'An example of feed forward');
num_layers = length(cnn.layers);
n_rows = length(cnn.layers{end}.a);
n_cols = num_layers + 3;
sample_ind = 101; 
value_range = [0 1];
for i = 1:num_layers
    switch cnn.layers{i}.type
        % plot input image
        case 'input'
            subplot(n_rows, n_cols, 1:n_cols:(n_rows*n_cols))
            img = cnn.layers{i}.a{1}(:,:,sample_ind);
            title_str = 'Input';
            imagesc(img, value_range);
            colormap gray
            axis image
            set(gca, ...
                'xticklabel', [], ...
                'yticklabel', [], ...
                'ticklength', [0 0])
            title(title_str, 'fontsize', 14)
            
        % plot maps after convolution
        case 'convolution'
            img_size = size(cnn.layers{i}.a{1});
            title_str = 'Conv';
            span = n_rows / length(cnn.layers{i}.a);
            for j = 1:length(cnn.layers{i}.a)
                locs = [];
                for k = 1:span 
                    locs = [locs (j-1)*span*n_cols+(k-1)*n_cols+i];
                end
                subplot(n_rows, n_cols, locs)
                img = cnn.layers{i}.a{j}(:,:,sample_ind);
                imagesc(img, value_range);
                colormap gray
                axis image
                set(gca, ...
                    'xticklabel', [], ...
                    'yticklabel', [], ...
                    'ticklength', [0 0])
                if j == 1
                    title(title_str, 'fontsize', 14)
                end
            end
                
        % plot maps after pooling        
        case 'mean-pool'
            img_size = size(cnn.layers{i}.a{1});
            title_str = 'Pool';
            span = n_rows / length(cnn.layers{i}.a);
            for j = 1:length(cnn.layers{i}.a)
                locs = [];
                for k = 1:span 
                    locs = [locs (j-1)*span*n_cols+(k-1)*n_cols+i];
                end
                subplot(n_rows, n_cols, locs)
                img = cnn.layers{i}.a{j}(:,:,sample_ind);
                imagesc(img, value_range);
                colormap gray
                axis image
                set(gca, ...
                    'xticklabel', [], ...
                    'yticklabel', [], ...
                    'ticklength', [0 0])
                if j == 1
                    title(title_str, 'fontsize', 14)
                end
            end
    end
end

% plot fully-connected layer
subplot(n_rows, n_cols, (n_cols-2):n_cols:(n_rows*n_cols))        
img = cnn.fc_1_a(:,sample_ind);
imagesc(img, value_range);
colormap gray
axis image
set(gca, ...
    'xticklabel', [], ...
    'yticklabel', [], ...
    'ticklength', [0 0])
title('FC_1', 'fontsize', 14)

subplot(n_rows, n_cols, (n_cols-1):n_cols:(n_rows*n_cols))        
img = cnn.fc_2_a(:,sample_ind);
imagesc(img, value_range);
colormap gray
axis image
set(gca, ...
    'xticklabel', [], ...
    'yticklabel', [], ...
    'ticklength', [0 0])
title('FC_2', 'fontsize', 14)

% plot output layer
subplot(n_rows, n_cols, n_cols:n_cols:(n_rows*n_cols))        
img = cnn.output(:,sample_ind);
imagesc(img, value_range);
colormap gray
axis image
set(gca, ...
    'xticklabel', [], ...
    'yticklabel', [1:9,0], ...
    'ticklength', [0 0], ...
    'fontsize', 14, ...
    'ytick', 1:10 ...
    )
title('Output', 'fontsize', 14)
%% 
figure('numberTitle', 'off', 'name', ...
    'Batch-wise mean squared error during training'); 
plot(cnn.rL, 'linewidth', 2);
xlabel('Batches')
ylabel('Mean squared error')
set(gca, 'fontsize', 16, ...
    'xlim', [0 length(cnn.rL)], ...
    'ylim', [0 ceil(max(cnn.rL)*10)*.1]);
grid on
end