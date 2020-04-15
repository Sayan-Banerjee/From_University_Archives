function net = WeightAdjustments(net, options)
    for l = 2 : numel(net.layers)
        if strcmp(net.layers{l}.type, 'convolution')
            for j = 1 : numel(net.layers{l}.a)
                for ii = 1 : numel(net.layers{l - 1}.a)
                    net.layers{l}.k{j}{ii} = net.layers{l}.k{j}{ii} - options.alpha * net.layers{l}.dk{j}{ii};
                end
                net.layers{l}.b{j} = net.layers{l}.b{j} - options.alpha * net.layers{l}.db{j};
            end
        end
    end

    net.fcW_1 = net.fcW_1 - options.alpha * net.dfcW_1;
    net.fcb_1 = net.fcb_1 - options.alpha * net.dfcb_1;
    net.fcW_2 = net.fcW_2 - options.alpha * net.dfcW_2;
    net.fcb_2 = net.fcb_2 - options.alpha * net.dfcb_2;
end
