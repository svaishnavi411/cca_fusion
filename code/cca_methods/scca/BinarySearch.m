function d=BinarySearch(a,c)
    
    if (sum(abs(projl2(a)))<=c) %constraint already satisfied
        d=0;
        return;
    end 
    
    d_l=0;
    d_h=max(abs(a));
    
    iter=0;
    while (iter<1500 && (d_h-d_l)>1e-5)
        u=projl2(soft_threshold(a, (d_l+d_h)/2));
        
        if (sum(abs(u))<c-1e-4)
            d_h=(d_l+d_h)/2;
        elseif (sum(abs(u))>c+1e-4)
            d_l=(d_l+d_h)/2;
        else
            d=(d_l+d_h)/2;
            return;
        end 
        
        iter=iter+1;
    end
    
%     warning('Binary Search Procedure NOT Converge!');
    d=(d_l+d_h)/2;
    
end 
