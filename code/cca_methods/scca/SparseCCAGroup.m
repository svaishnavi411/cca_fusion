function [u, v]=SparseCCAGroup(XY, lambda_x, lambda_y, T_x, w_x, T_y, w_y, para)
% Group structured sparse CCA  
% Input:
%   X, Y: data
%   lambda_x, lambda_y: regularization parameter for X and Y (c_1 or theta
%   in Eq.(3) in SSCCA paper)
%   T_x, w_x, group structure and weights for X side (if they are empty,
%   then simply use L1-constraint)
%   T_y, w_y  group structure and weights for Y side (if they are empty,
%   then simply use L1-constraint)
%   para: parameter
%   For simplicity, we assume the parameter tau is 1
% Output
%   coefficients u for X side
%   coefficients v for Y side
%   cor: correlation

%% Set up parameters
    if exist('para', 'var') && isfield(para, 'verbose')
        verb=para.verbose;  % verbose for printing
    else
        verb=true;
    end
    
    if exist('para', 'var') && isfield(para, 'tol')
        tol=para.tol;  % tol for algorithm
    else
        tol=1e-4;
    end
    
    if exist('para', 'var') && isfield(para, 'maxiter')
        maxiter= para.maxiter;
    else
        maxiter=50;
    end
    
    if exist('para', 'var') && isfield(para, 'threshold')
        threshold= para.threshold;
    else
        threshold=1e-5;
    end
    
    if exist('para', 'var') && isfield(para, 'inner_verbose')
        inner_verb=para.inner_verbose;  % verbose for printing
    else
        inner_verb=false;
    end
    
    if exist('para', 'var') && isfield(para, 'inner_tol')
        inner_tol=para.inner_tol;  % tol for algorithm
    else
        inner_tol=1e-6;
    end
    
    if exist('para', 'var') && isfield(para, 'inner_maxiter')
        inner_maxiter= para.inner_maxiter;
    else
        inner_maxiter=1000;
    end
    
    inner_para=struct('verbose', inner_verb, 'tol', inner_tol, 'maxiter', inner_maxiter);


    
    if isempty(T_x) || isempty(w_x)
        group_x_tag=false;  % group on x side
    else
        group_x_tag=true;
    end
    
    if isempty(T_y) || isempty(w_y)
        group_y_tag=false;  % group on y side
    else
        group_y_tag=true;
    end   
    
    %% Alternating Procedure
    
    % initialization
    col_X=size(XY,1);
    col_Y=size(XY,2);    
    u_old=projl2(randn(col_X,1));
    v_old=projl2(randn(col_Y,1));    

    U = [u_old];
    V = [v_old];
    
    iter=0;
    while (iter<maxiter)

        if (group_x_tag)
            u=group_exgap(XY*v_old, lambda_x, T_x, w_x, inner_para);
        else
            u=maxL1L2(XY*v_old, lambda_x);
        end
        u_gap=max(abs(u-u_old));
        u_old=u;

        if (group_y_tag)
            v=group_exgap(XY'*u_old, lambda_y, T_y, w_y, inner_para);                
        else
            v=maxL1L2(XY'*u_old, lambda_y);
        end

        v_gap=max(abs(v-v_old));
        v_old=v;
        
        if (verb)
            fprintf('Iter=%d, u_gap=%f, v_gap=%f\n', iter, u_gap, v_gap);
        end

        if (u_gap<tol && v_gap<tol)
            break
        end
        
        iter=iter+1;
        
    end       
    u(abs(u)<threshold)=0;
    v(abs(v)<threshold)=0;
    
    if (any(u))
        u=u/sqrt(sum(u.^2));        
    end
    if (any(v))
        v=v/sqrt(sum(v.^2));
    end
%     cor=cov(X*u, Y*v);
%     cor=cor(1,2);
    
end
