function u=maxL1L2(a,c)
% implement Lemma 2.2. in [A penalized matrix decomposition, with applications to
%sparse principal components and canonical correlation analysis] 

    if c>=sqrt(length(a)) %since this means that the L1 norm constraint is inactive. 
        u=projl2(a);
    elseif c<=1 %the L1 norm is the only constraint that is active in this case.
        [v, idx]=max(abs(a));
        u=zeros(length(a),1);
        u(idx)=sign(a(idx))*c;
    else 
        delta=BinarySearch(a,c);  % here it is inherently assumed that c is chosen such that the L2 norm constraint is necessarily active... so what happens if that's not the case? you probably somewhat ignore the L1 constraint then..
        u=projl2(soft_threshold(a, delta));
%         disp(norm(u, 1))
%         disp(c)
    end
    
end  
