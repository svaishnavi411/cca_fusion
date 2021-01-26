function [x, primal_obj, dual_obj, rel_gap, iter]=group_exgap(y, gamma, T, w, para)
% Excessive Gap for the Constrained Proximal Mapping with Overlapping
% Group Lasso Penalty
% Input:
%   y: input data;
%   gamma: global regularization parameter
%   T: group indictor sparse matrix
%   w: weight for each group
%   Para: parameters
%Output:
%   x: estimated coefficients
%   primal_obj: primal objective
%   dual_obj: dual objective
%   rel_gap: relative gap
%   iter:   number of iterations

%%  Set parameters
    
    if exist('para', 'var') && isfield(para, 'verbose')
        verb=para.verbose;  % verbose for printing
    else
        verb=false;
    end
    
    if exist('para', 'var') && isfield(para, 'tol')
        tol=para.tol;  % tol for algorithm
    else
        tol=1e-6;
    end
    
    if exist('para', 'var') && isfield(para, 'maxiter')
        maxiter= para.maxiter;
    else
        maxiter=1000;
    end
    
%%  Pre-processing for Exgap Methods with group     
    [C, g_idx, L] = pre_group(T, w, gamma);
 
%%  Initialization 
    mu=2*L;

    % initial x
    if (norm(y,2)>=1)
        x_old=y/sqrt(sum(y.^2));
    else 
        x_old=y;
    end     
    
    % initial dual variable alpha
    Cx=full(C*x_old);    
    a=shrink_group(Cx/L, g_idx); % shrink to make sure L2-norm for each group in "a" is less than or equal to 1

%%  Excessive Gap Method (see Algorithm 1 in the SSCCA paper)

    iter=0;
    while(iter<=maxiter)        
        
        tau=2/(iter+3);   
        
        z=(1-tau)*a+tau*shrink_group(Cx/mu, g_idx);
        
        mu=(1-tau)*mu;
        
        x0=y-C'*z;
        if (norm(x0,2)>=1)
            x0=x0/sqrt(sum(x0.^2));
        end 
        
        x=(1-tau)*x_old+tau*x0;
        Cx=full(C*x);
        a=shrink_group(z+Cx/L, g_idx);
        
        primal_obj= sum((x-y).^2)/2+cal2norm(C*x, g_idx); 
        dual_obj= sum((x-y).^2)/2 + x'*C'*a;
        rel_gap=abs(dual_obj-primal_obj)/(1+abs(dual_obj)+abs(primal_obj));
        
        
        if (verb)
            fprintf('Iter=%d, Primal_Obj=%.3f, Dual_Obj=%.3f, Rel_Gap=%.3f\n', iter, primal_obj, dual_obj, rel_gap);
        end 
        
        if (rel_gap<tol)
            break;
        end       
        
        iter=iter+1;       
        x_old=x;
    end

end 