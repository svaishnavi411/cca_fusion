function [U, V] = k_scca(X, Y, paras)

    addpath('../1_cca_methods/scca/')
    addpath('../2_deflation_method/')
    
    XY = X'*Y;
%     XX = X'*X;
%     YY = Y'*Y;
    
    p = size(X,2);
    q = size(Y,2);

    U = zeros(p, paras.K);
    V = zeros(q, paras.K);
    
    for k = 1:paras.K
    
        [u, v] = scca(XY, paras);
        
        u = u/norm(u);
        v = v/norm(v);
        
        U(:, k) = u;
        V(:, k) = v;
        
        [XY] = hotelling_deflation_normalized(XY, u, v);
        
    end
        
end
