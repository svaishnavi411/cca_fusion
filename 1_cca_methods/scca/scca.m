function [u, v] = scca(XY, paras)

% if sum(strcmp(fieldnames(paras), 'track')) == 1
%     [u, v, ~] = SparseCCAGroup(X, Y, paras.lambda1, paras.lambda2, [], [], [], [], struct('track', paras.track, 'prefix', paras.prefix));
% else
    
[u, v] = SparseCCAGroup(XY, paras.lambda1, paras.lambda2, [], [], [], [], []);
    
u = u / norm(u);
v = v / norm(v);
end

