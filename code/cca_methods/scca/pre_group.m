function [C, g_idx, L] = pre_group(T, Tw, gamma)
% Preprocessing for Group Penalty for Exgap Method
% Input: 
%   Group indicator sparse matrix T
%   Weight matrix: Tw
%   regularization parameter: gamma
% Output:
%   C:  matrix (group indicator from the dual norm, see the SSCCA paper)
%   g_idx: Each row is the range of features for a group
%   L: Lipschitiz constant for smoothed penalty

    [V K] = size(T);
    sum_col_T=full(sum(T,2));
    SV=sum(sum_col_T);
    csum=cumsum(sum_col_T);
    g_idx=[[1;csum(1:end-1)+1], csum, sum_col_T]; %each row is the range of the group
    
    %% Construct C matrix
    J=zeros(SV,1);
    W=zeros(SV,1);
    for v=1:V
       J(g_idx(v,1):g_idx(v,2))=find(T(v,:));
       W(g_idx(v,1):g_idx(v,2))=Tw(v);
    end 
    C=gamma*sparse(1:SV, J, W, SV, K);
    
    %% Compute Lipscthiz constant for the smoothed group penalty according to Proposition 2
    L=gamma^2*full(max(sum(T.^2)));     

end 