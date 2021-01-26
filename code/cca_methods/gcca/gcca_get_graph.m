function [L1, L2] = gcca_get_graph(X, Y, paras)
    
if strcmp(paras.mode, 'prior1')
    L1 = paras.L1;
elseif strcmp(paras.mode, 'no-prior')
    L1 = getGroupInfo(X,'lp');
else
    error('Not implemented')
end
L2 = getGroupInfo(Y,'lp');

end
