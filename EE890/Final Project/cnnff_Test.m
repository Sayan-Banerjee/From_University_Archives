function net = cnnff_Test(net, x)
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    inputmaps = 1;

    for l = 2 : n   %  for each layer
        if strcmp(net.layers{l}.type, 'convolution')
            for j = 1 : net.layers{l}.outputmaps   %  for each output map
                %  create temp output map
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]);
                for i = 1 : inputmaps   %  for each input map
                    %  convolve with corresponding kernel and add to temp output map
                    filter=rot180(squeeze(net.layers{l}.k{j}{i}));
                    z = z + convn(net.layers{l - 1}.a{i}, filter,'valid');
                    %z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{j}{i}, 'valid');
                end
                %  add bias, pass through nonlinearity
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});
            end
            %  set number of input maps to this layers number of outputmaps
            inputmaps = net.layers{l}.outputmaps;
        elseif strcmp(net.layers{l}.type, 'mean-pool')
            %  downsample
            for j = 1 : inputmaps
                z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');
                net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :);
            end
        end
    end

    %  concatenate all end layer feature maps into vector
    net.fv_1 = [];
    for j = 1 : numel(net.layers{n}.a)
        sa = size(net.layers{n}.a{j});
        net.fv_1 = [net.fv_1; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))];
    end
   
    net.fv_2 = sigm(net.ffW_1 * net.fv_1 + repmat(net.ffb_1, 1, size(net.fv_1, 2)));
    net.o= sigm(net.ffW_2 * net.fv_2 + repmat(net.ffb_2, 1, size(net.fv_2, 2)));
end
