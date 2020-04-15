function net = BackPropagation(net, y)
    n = numel(net.layers);

    %   error
    net.error = net.output - y;
    %  loss function
    net.Loss = 1/2* sum(net.error(:) .^ 2) / size(net.error, 2);

    %%  backprop deltas
    net.output_d = net.error .* (net.output .* (1 - net.output));   %  output delta
    net.fc_2_d = (net.fcW_2' * net.output_d);              %  feature vector delta
    net.fc_2_d = net.fc_2_d .* (net.fc_2_a .* (1 - net.fc_2_a));
    net.fc_1_d = (net.fcW_1' * net.fc_2_d);
    if strcmp(net.layers{n}.type, 'convolution')         %  only conv layers has sigm function
        net.fc_1_d = net.fc_1_d .* (net.fc_1_a .* (1 - net.fc_1_a));
    end

    %  reshape feature vector deltas into output map style
    size_a = size(net.layers{n}.a{1});
    fc_n = size_a(1) * size_a(2);
    for j = 1 : numel(net.layers{n}.a)
        net.layers{n}.d{j} = reshape(net.fc_1_d(((j - 1) * fc_n + 1) : j * fc_n, :), size_a(1), size_a(2), size_a(3));
    end

    for l = (n - 1) : -1 : 1
        if strcmp(net.layers{l}.type, 'convolution')
            for j = 1 : numel(net.layers{l}.a)
                net.layers{l}.d{j} = net.layers{l}.a{j} .* (1 - net.layers{l}.a{j}) .* (expand(net.layers{l + 1}.d{j}, [net.layers{l + 1}.scale net.layers{l + 1}.scale 1]) / net.layers{l + 1}.scale ^ 2);
            end
        elseif strcmp(net.layers{l}.type, 'mean-pool')
            for i = 1 : numel(net.layers{l}.a)
                z = zeros(size(net.layers{l}.a{1}));
                for j = 1 : numel(net.layers{l + 1}.a)
                     z = z + convn(net.layers{l + 1}.d{j}, net.layers{l + 1}.k{j}{i}, 'full');
                end
                net.layers{l}.d{i} = z;
            end
        end
    end

    %%  calc gradients
    for l = 2 : n
        if strcmp(net.layers{l}.type, 'convolution')
            for j = 1 : numel(net.layers{l}.a)
                for i = 1 : numel(net.layers{l - 1}.a)
                    
                    net.layers{l}.dk{j}{i} = convn(net.layers{l - 1}.a{i}, flipall(net.layers{l}.d{j}), 'valid') / size(net.layers{l}.d{j}, 3);
                end
                net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:)) / size(net.layers{l}.d{j}, 3);
            end
        end
    end
    net.dfcW_1 = net.fc_2_d * (net.fc_1_a)' / size(net.fc_2_d, 2);
    net.dfcb_1 = mean(net.fc_2_d, 2);
    net.dfcW_2 = net.output_d * (net.fc_2_a)' / size(net.output_d, 2);
    net.dfcb_2 = mean(net.output_d, 2);

end
