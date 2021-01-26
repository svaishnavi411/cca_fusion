function [b, T, w]=gentoy(ng, g_size, overlap)
%   Function for Generate Toy Data
%   Please refer to Sparse CCA paper Section 5.1

%   Input arguments:
%       ng: the number of groups
%       g_size: size for each group
%       overlap: number(#) of features that are overlapped in two
%       consecutive groups
%
%   Output arguments:
%       b: generated data (first half are one and all other elements are
%       zero
%       T: sparse matrix indicate each group contains which variables  
%       size of T: ng times total number of features,
%       w: weight for each group

    %%  construct the data x where the first half of variables are 1

    d=ng*(g_size-overlap)+overlap;    % total number of features
    supp=1:floor((g_size-overlap)*ng/2);   
    b= zeros(d,1);    
    b(supp)=1;   
    
    %%  construct group indicator matrix T
    s=1;                        
    I=zeros(ng*g_size, 1);
    J=zeros(ng*g_size, 1);
    for g=1:ng
        I(g_size*(g-1)+1:g_size*g)=g;
        J(g_size*(g-1)+1:g_size*g)=s:s+g_size-1;
        s=s+g_size-overlap;
    end
    T=sparse(I,J,1,ng,d);
    
    %% Construct weights for each group    
    w=ones(ng,1); 
end     
