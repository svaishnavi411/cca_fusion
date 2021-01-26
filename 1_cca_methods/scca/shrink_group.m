function r=shrink_group(a, g_idx)
% shrink to make sure L2-norm for each group is less than or equal to 1

    V=size(g_idx,1);  % number of groups     
    r=a;    
    for v=1:V
        idx=g_idx(v,1):g_idx(v,2);
        gnorm=sqrt(sum(a(idx).^2));
        if (gnorm>1)
            r(idx)=a(idx)/gnorm;
        end
    end 
    
end