function run_k_gcca_on_brca(mode)
%% This code is to run GCCA on the BRCA data

base_dir = '/mnt/data0-nfs/vs5/repos/cca_fusion_cancer/';
data_loc = strcat(base_dir, 'data/brca/');

addpath(strcat(base_dir, 'code/k_cca_methods/'))
addpath(strcat(base_dir, 'code/data_preprocessing'))
addpath(strcat(base_dir, 'code/cca_methods/gcca/'))
addpath(strcat(base_dir, 'code/deflation_method/'))

save_file_prefix = strcat(base_dir, 'results/brca_k_gcca/');
load_file_prefix = strcat(base_dir, 'results/brca_1_gcca/');
%% Load files and run K-GCCA based

tic

if strcmp(mode, 'prior1')

    for num_genes = [500, 800, 1000, 3000]

        L_graph = table2array(readtable(strcat(data_loc, ...
            '/ordered_laplacians/ordered_graph_laplacian_', num2str(num_genes), '.csv')));
        L_graph = L_graph / norm (L_graph);

        save_folder = strcat(save_file_prefix, num2str(num_genes), '_prior');
        load_folder = strcat(load_file_prefix, num2str(num_genes), '_prior');
        mkdir(save_folder);

        for fold_num = 0:4

            X_train = table2array(readtable(strcat(data_loc, 'train/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/genes.csv')));
            Y_train = table2array(readtable(strcat(data_loc, 'train/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/image.csv')));

            X_valid = table2array(readtable(strcat(data_loc, 'valid/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/genes.csv')));
            Y_valid = table2array(readtable(strcat(data_loc, 'valid/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/image.csv')));

            X_test = table2array(readtable(strcat(data_loc, 'test/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/genes.csv')));
            Y_test = table2array(readtable(strcat(data_loc, 'test/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/image.csv')));

            % Run normalization on data
            X_valid = getNormalization(X_valid, X_train);
            Y_valid = getNormalization(Y_valid, Y_train);

            % Run normalization on data
            X_test = getNormalization(X_test, X_train);
            Y_test = getNormalization(Y_test, Y_train);
            
            % Run normalization on data
            X_train = getNormalization(X_train, X_train);
            Y_train = getNormalization(Y_train, Y_train);

            load_filename = strcat(load_folder, '/', num2str(fold_num), '.mat');
            load(load_filename);

            data = struct('X_train', X_train, ...
                          'Y_train', Y_train, ...
                          'X_valid', X_valid, ...
                          'Y_valid', Y_valid, ...
                          'mode', mode, ...
                          'L1', L_graph, ...
                          'K', 100, ...
                          'best_struct', best_struct);
                      
            [U, V] = pick_best_k_gcca(data);
            
            X_embedding = U'* X_test';
            Y_embedding = V'* Y_test';
            test_correlations = (diag(X_embedding*Y_embedding')./(sqrt(diag(X_embedding*X_embedding')).*sqrt(diag(Y_embedding*Y_embedding'))));
            
            curr_filename = strcat(save_folder, '/', num2str(fold_num), '.mat');
            save(curr_filename, 'U', 'V', 'X_embedding', 'Y_embedding', 'test_correlations');
        end
    end
    toc
    
%% Load files and run K-GCCA based

elseif strcmp(mode, 'no-prior') 
    tic

    for num_genes = [500, 800, 1000, 3000]

        save_folder = strcat(save_file_prefix, num2str(num_genes), '_no_prior');
        load_folder = strcat(load_file_prefix, num2str(num_genes), '_no_prior');
        mkdir(save_folder);

        for fold_num = 0:4

            X_train = table2array(readtable(strcat(data_loc, 'train/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/genes.csv')));
            Y_train = table2array(readtable(strcat(data_loc, 'train/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/image.csv')));

            X_valid = table2array(readtable(strcat(data_loc, 'valid/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/genes.csv')));
            Y_valid = table2array(readtable(strcat(data_loc, 'valid/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/image.csv')));

            X_test = table2array(readtable(strcat(data_loc, 'test/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/genes.csv')));
            Y_test = table2array(readtable(strcat(data_loc, 'test/', num2str(num_genes), '/', ...
                                  num2str(fold_num), '/image.csv')));

            % Run normalization on data
            X_valid = getNormalization(X_valid, X_train);
            Y_valid = getNormalization(Y_valid, Y_train);

            % Run normalization on data
            X_test = getNormalization(X_test, X_train);
            Y_test = getNormalization(Y_test, Y_train);

            % Run normalization on data
            X_train = getNormalization(X_train, X_train);
            Y_train = getNormalization(Y_train, Y_train);

            load_filename = strcat(load_folder, '/', num2str(fold_num), '.mat');
            load(load_filename);
            
            data = struct('X_train', X_train, ...
                          'Y_train', Y_train, ...
                          'X_valid', X_valid, ...
                          'Y_valid', Y_valid, ...
                          'mode', mode, ...
                          'L1', [], ...
                          'K', 100, ...
                          'best_struct', best_struct);
                      
            [U, V] = pick_best_k_gcca(data);
            
            X_embedding = U'* X_test';
            Y_embedding = V'* Y_test';
            test_correlations = (diag(X_embedding*Y_embedding')./(sqrt(diag(X_embedding*X_embedding')).*sqrt(diag(Y_embedding*Y_embedding'))));
            
            curr_filename = strcat(save_folder, '/', num2str(fold_num), '.mat');
            save(curr_filename, 'U', 'V', 'X_embedding', 'Y_embedding', 'test_correlations');
        end
    end

    toc
end
end
