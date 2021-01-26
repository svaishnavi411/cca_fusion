function [L1, L2] = gcca_get_graph(X, Y, paras)
    
base_dir = '/mnt/data0-nfs/vs5/repos/structured_cca/isbi_cleaned_up/';
addpath(strcat(base_dir, '1_cca_methods/data_preprocessing'))

if strcmp(paras.mode, 'prior1')
    L1 = paras.L1;
elseif strcmp(paras.mode, 'no-prior')
    L1 = getGroupInfo(X,'lp');
else
    error('Not implemented')
end
L2 = getGroupInfo(Y,'lp');

end
