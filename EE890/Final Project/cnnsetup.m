function net = cnnsetup(net, x, y)
    inputmaps = 1;
    mapsize = size(squeeze(x(:, :, 1)));

    for l = 1 : numel(net.layers)   %  layer
        if strcmp(net.layers{l}.type, 'mean-pool')
            mapsize = mapsize / net.layers{l}.scale;
            assert(all(floor(mapsize)==mapsize), ['Layer ' num2str(l) ' size must be integer. Actual: ' num2str(mapsize)]);
%             for j = 1 : inputmaps
%                 net.layers{l}.b{j} = 0;
%             end
        end
        if strcmp(net.layers{l}.type, 'convolution')
            mapsize = mapsize - net.layers{l}.kernelsize + 1;
            fan_out = net.layers{l}.outputmaps * net.layers{l}.kernelsize ^ 2;
            for j = 1 : net.layers{l}.outputmaps  %  output map
                fan_in = inputmaps * net.layers{l}.kernelsize ^ 2;
                for i = 1 : inputmaps  %  input map
                    net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize) - 0.5) * 2 * sqrt(6 / (fan_in + fan_out));
                end
                net.layers{l}.b{j} = 0;
            end
            inputmaps = net.layers{l}.outputmaps;
        end
    end
    
    fvnum_1 = prod(mapsize) * inputmaps;
    fvnum_2 = ceil(fvnum_1/4);
    %fvnum_2=32;
    onum = size(y, 1);

    net.ffb_1 = zeros(fvnum_2, 1);
    net.ffW_1 = (rand(fvnum_2, fvnum_1) - 0.5) * 2 * sqrt(6 / (fvnum_2 + fvnum_1));
    net.ffb_2 = zeros(onum, 1);
    net.ffW_2 = (rand(onum, fvnum_2) - 0.5) * 2 * sqrt(6 / (onum + fvnum_2));
end
