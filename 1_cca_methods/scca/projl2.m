function b=projl2(a)

    if any(a)
        b=a/sqrt(sum(a.^2));
    else
        b=a;
    end
    
end