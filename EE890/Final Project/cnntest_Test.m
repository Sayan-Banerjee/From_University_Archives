function [err_rate, net, bad, est] = cnntest_Test(net, x, y)
    %  feedforward
    net = cnnff_Test(net, x);
    [~, est] = max(net.o);
    [~, tru] = max(y);
    bad = find(est ~= tru);

    err_rate = numel(bad) / size(y, 2);
end
