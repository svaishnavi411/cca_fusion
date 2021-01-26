function [U, V] = k_gcca(X, Y, paras)

    addpath('../1_cca_methods/gcca/')
    addpath('../2_deflation_method/')
    
    XY = X'*Y;
    XX = X'*X;
    YY = Y'*Y;
    
    p = size(X,2);
    q = size(Y,2);

    U = zeros(p, paras.K);
    V = zeros(q, paras.K);
    [L1, L2] = gcca_get_graph(X, Y, paras);
    
    for k = 1:paras.K
        disp(paras)
        disp(k)
        disp(p)
    
        [u, v] = gcca(XY, XX, YY, L1, L2, paras);
        
        u = u/norm(u);
        v = v/norm(v);
        
        U(:, k) = u;
        V(:, k) = v;
        
        [XY] = hotelling_deflation_normalized(XY, u, v);
        
    end
        
end
