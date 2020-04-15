function net = cnnbp_Test(net, y)
    n = numel(net.layers);

    %   error
    net.e = net.o - y;
    %  loss function
    net.L = 1/2* sum(net.e(:) .^ 2) / size(net.e, 2);

    %%  backprop deltas
    net.od = net.e .* (net.o .* (1 - net.o));   %  output delta
    net.fvd_2 = (net.ffW_2' * net.od);              %  feature vector delta
    net.fvd_2 = net.fvd_2 .* (net.fv_2 .* (1 - net.fv_2));
    net.fvd_1 = (net.ffW_1' * net.fvd_2);
    if strcmp(net.layers{n}.type, 'convolution')         %  only conv layers has sigm function
        net.fvd_1 = net.fvd_1 .* (net.fv_1 .* (1 - net.fv_1));
    end

    %  reshape feature vector deltas into output map style
    sa = size(net.layers{n}.a{1});
    fvnum = sa(1) * sa(2);
    for j = 1 : numel(net.layers{n}.a)
        net.layers{n}.d{j} = reshape(net.fvd_1(((j - 1) * fvnum + 1) : j * fvnum, :), sa(1), sa(2), sa(3));
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
                    %net.layers{l}.dk{j}{i} = convn(flipall(net.layers{l - 1}.a{i}), net.layers{l}.d{j}, 'valid') / size(net.layers{l}.d{j}, 3);
                    net.layers{l}.dk{j}{i} = convn(net.layers{l - 1}.a{i}, flipall(net.layers{l}.d{j}), 'valid') / size(net.layers{l}.d{j}, 3);
                end
                net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:)) / size(net.layers{l}.d{j}, 3);
            end
        end
    end
    net.dffW_1 = net.fvd_2 * (net.fv_1)' / size(net.fvd_2, 2);
    net.dffb_1 = mean(net.fvd_2, 2);
    net.dffW_2 = net.od * (net.fv_2)' / size(net.od, 2);
    net.dffb_2 = mean(net.od, 2);

end
