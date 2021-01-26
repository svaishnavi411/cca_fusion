function run_1_gcca_on_brca(mode)
%% This code is to run GCCA on the BRCA data

base_dir = '/mnt/data0-nfs/vs5/repos/structured_cca/isbi_cleaned_up/';
data_loc = strcat(base_dir, '0_data/');

addpath(strcat(base_dir, '3_k_cca_methods/'))
addpath(strcat(base_dir, '1_cca_methods/data_preprocessing'))

save_file_prefix = strcat(base_dir, '7_results/brca_1_gcca/');
%% Load files and run 1-GCCA based

tic

if strcmp(mode, 'prior1')

%    for num_genes = [500, 800, 1000, 3000]
    for num_genes = [3000]

        L_graph = table2array(readtable(strcat(data_loc, ...
            '/ordered_graph_laplacian_', num2str(num_genes), '.csv')));
        L_graph = L_graph / norm (L_graph);

        save_folder = strcat(save_file_prefix, num2str(num_genes), '_prior');
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

            data = struct('X_train', X_train, ...
                          'Y_train', Y_train, ...
                          'X_valid', X_valid, ...
                          'Y_valid', Y_valid, ...
                          'mode', mode, ...
                          'L1', L_graph);
            [u, v, best_struct] = pick_best_k_gcca(data);
            curr_filename = strcat(save_folder, '/', num2str(fold_num), '.mat');
            
            est_x_variate = u'*X_test';
            est_y_variate = v'*Y_test';    
            test_correlation = est_x_variate*est_y_variate'/(sqrt(est_x_variate*est_x_variate')*sqrt(est_y_variate*est_y_variate'));

            save(curr_filename, 'u', 'v', 'test_correlation', 'best_struct');
        end
    end
    toc
    
%% Load files and run 1-GCCA based

elseif strcmp(mode, 'no-prior') 
    tic

%    for num_genes = [500, 800, 1000, 3000]
    for num_genes = [3000]

        save_folder = strcat(save_file_prefix, num2str(num_genes), '_no_prior');
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

            data = struct('X_train', X_train, ...
                          'Y_train', Y_train, ...
                          'X_valid', X_valid, ...
                          'Y_valid', Y_valid, ...
                          'mode', mode);
            [u, v, best_struct] = pick_best_k_gcca(data);
            curr_filename = strcat(save_folder, '/', num2str(fold_num), '.mat');
            
            est_x_variate = u'*X_test';
            est_y_variate = v'*Y_test';    
            test_correlation = est_x_variate*est_y_variate'/(sqrt(est_x_variate*est_x_variate')*sqrt(est_y_variate*est_y_variate'));

            save(curr_filename, 'u', 'v', 'test_correlation', 'best_struct');
        end
    end

    toc
end
end
