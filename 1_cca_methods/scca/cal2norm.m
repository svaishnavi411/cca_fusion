function s=cal2norm(a, g_idx)
% calculate the sum of the L2-norm for each group
         V=size(g_idx,1);
         s=0;
         for v=1:V
             idx=g_idx(v,1):g_idx(v,2);
             gnorm=sqrt(sum(a(idx).^2));
             s=s+sum(gnorm);
         end
end