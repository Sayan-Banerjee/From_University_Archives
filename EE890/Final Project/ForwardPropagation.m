function net = ForwardPropagation(net, x)
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    input_depth = 1;

    for l = 2 : n  
        if strcmp(net.layers{l}.type, 'convolution')
            for j = 1 : net.layers{l}.output_depth   
                
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]);
                for i = 1 : input_depth   
                    
                    filter=rot180(squeeze(net.layers{l}.k{j}{i}));
                    z = z + convn(net.layers{l - 1}.a{i}, filter,'valid');
                    
                end
                
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});
            end
            
            input_depth = net.layers{l}.output_depth;
        elseif strcmp(net.layers{l}.type, 'mean-pool')
            
            for j = 1 : input_depth
                z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');
                net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :);
            end
        end
    end

    
    net.fc_1_a = [];
    for j = 1 : numel(net.layers{n}.a)
        size_a = size(net.layers{n}.a{j});
        net.fc_1_a = [net.fc_1_a; reshape(net.layers{n}.a{j}, size_a(1) * size_a(2), size_a(3))];
    end
   
    net.fc_2_a = sigm(net.fcW_1 * net.fc_1_a + repmat(net.fcb_1, 1, size(net.fc_1_a, 2)));
    net.output= sigm(net.fcW_2 * net.fc_2_a + repmat(net.fcb_2, 1, size(net.fc_2_a, 2)));
end
