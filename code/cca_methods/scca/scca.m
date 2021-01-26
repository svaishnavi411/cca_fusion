function [u, v] = scca(XY, paras)
    
[u, v] = SparseCCAGroup(XY, paras.lambda1, paras.lambda2, [], [], [], [], []);
    
u = u / norm(u);
v = v / norm(v);
end

