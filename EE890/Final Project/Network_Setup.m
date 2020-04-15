function net = Network_Setup(net, x, y)
    input_depth = 1;
    mapsize = size(squeeze(x(:, :, 1)));

    for l = 1 : numel(net.layers)   
        if strcmp(net.layers{l}.type, 'mean-pool')
            mapsize = mapsize / net.layers{l}.scale;
            assert(all(floor(mapsize)==mapsize), ['Layer ' num2str(l) ' size must be integer. Actual: ' num2str(mapsize)]);
        end
        if strcmp(net.layers{l}.type, 'convolution')
            mapsize = mapsize - net.layers{l}.kernelsize + 1;
            outputs = net.layers{l}.output_depth * net.layers{l}.kernelsize ^ 2;
            for j = 1 : net.layers{l}.output_depth  
                inputs = input_depth * net.layers{l}.kernelsize ^ 2;
                for i = 1 : input_depth  
                    net.layers{l}.k{j}{i} = (rand(net.layers{l}.kernelsize) - 0.5) * 2 * sqrt(6 / (inputs + outputs));
                end
                net.layers{l}.b{j} = 0;
            end
            input_depth = net.layers{l}.output_depth;
        end
    end
    
    fc_1 = prod(mapsize) * input_depth;
    fc_2 = ceil(fc_1/4);
    class = size(y, 1);

    net.fcb_1 = zeros(fc_2, 1);
    net.fcW_1 = (rand(fc_2, fc_1) - 0.5) * 2 * sqrt(6 / (fc_2 + fc_1));
    net.fcb_2 = zeros(class, 1);
    net.fcW_2 = (rand(class, fc_2) - 0.5) * 2 * sqrt(6 / (class + fc_2));
    net.rL = [];
end
