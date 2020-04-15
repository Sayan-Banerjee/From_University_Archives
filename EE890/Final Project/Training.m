function net = Training(net, x, y, options)
    m = size(x, 3);
    numbatches = m / options.batchsize;
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    h = waitbar(0, '', 'name', 'Training CNN ...');
    for i = 1 : options.numepochs % for each epoch
        fprintf('Epoch\t%2d/%2d\n', i, options.numepochs);
        start_epoch = tic;
        kk = randperm(m);
        for l = 1 : numbatches % for each batch
            waitbar(((i-1)*numbatches+l) / (numbatches*options.numepochs), ...
                h, sprintf('epoch %d/%d, batch %d/%d', ...
                i, options.numepochs, l, numbatches))
            
            batch_x = x(:, :, kk((l - 1) * options.batchsize + 1 : l * options.batchsize));
            batch_y = y(:,    kk((l - 1) * options.batchsize + 1 : l * options.batchsize));
            % feed forward
            net = ForwardPropagation(net, batch_x);
            % back propagation (gradient descent)
            net = BackPropagation(net, batch_y);
            % update parameters 
            net = WeightAdjustments(net, options);
            if isempty(net.rL)
                net.rL(1) = net.Loss;
            
            else
                if (options.batchsize < m)
                    net.rL(end + 1) = .9 * net.rL(end) + .1 * net.Loss;
                else
                    net.rL(end + 1) = net.Loss;
                end
            end
        end
        toc(start_epoch)
    end
    close(h)
end
