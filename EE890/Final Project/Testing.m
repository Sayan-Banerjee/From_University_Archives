function [err_rate, net, bad, est] = Testing(net, x, y)
    %  feedforward
    net = ForwardPropagation(net, x);
    [~, est] = max(net.output);
    [~, tru] = max(y);
    bad = find(est ~= tru);

    err_rate = numel(bad) / size(y, 2);
end
