function net = cnnapplygrads_Test(net, opts)
    for l = 2 : numel(net.layers)
        if strcmp(net.layers{l}.type, 'convolution')
            for j = 1 : numel(net.layers{l}.a)
                for ii = 1 : numel(net.layers{l - 1}.a)
                    net.layers{l}.k{j}{ii} = net.layers{l}.k{j}{ii} - opts.alpha * net.layers{l}.dk{j}{ii};
                end
                net.layers{l}.b{j} = net.layers{l}.b{j} - opts.alpha * net.layers{l}.db{j};
            end
        end
    end

    net.ffW_1 = net.ffW_1 - opts.alpha * net.dffW_1;
    net.ffb_1 = net.ffb_1 - opts.alpha * net.dffb_1;
    net.ffW_2 = net.ffW_2 - opts.alpha * net.dffW_2;
    net.ffb_2 = net.ffb_2 - opts.alpha * net.dffb_2;
end
