;function run_1_gcca_on_simulated(mode)

%% This code is to run GCCA on the saved simulated data

base_dir = '/mnt/data0-nfs/vs5/repos/cca_fusion/';
addpath(strcat(base_dir, 'code/k_cca_methods/'))
addpath(strcat(base_dir, 'code/data_preprocessing/'))
addpath(strcat(base_dir, 'code/cca_methods/gcca/'))
addpath(strcat(base_dir, 'code/deflation_method/'))

load_file_prefix = strcat(base_dir, 'data/simulated/');
save_file_prefix = strcat(base_dir, 'results/simulation_gcca/');

%% Load files and run 1-GCCA based

tic

if strcmp(mode, 'prior1')
    n_settings = [1000]; 
    p_settings = [100];  
    q_settings = [100];
    degree_settings = [5, 10, 25, 50];
    sigma_settings = [0.5, 0.75];

    for setting_idx = 1
        n = n_settings(setting_idx);
        p = p_settings(setting_idx);
        q = q_settings(setting_idx);
        for degree = degree_settings
            for sigma_factor = sigma_settings
                disp(degree)
                disp(sigma_factor)
                curr_folder = strcat(load_file_prefix, num2str(degree), '_', num2str(sigma_factor*100));
                save_folder = strcat(save_file_prefix, num2str(degree), '_', num2str(sigma_factor*100), '_prior');
                mkdir(save_folder);
                for itr = 1:25
                    curr_filename = strcat(curr_folder, '/', num2str(itr), '.mat');
                    load(curr_filename);
                    data = struct('X_train', X_train', ...
                                  'Y_train', Y_train', ...
                                  'X_valid', X_valid', ...
                                  'Y_valid', Y_valid', ...
                                  'mode', mode, ...
                                  'L1', L);
                    [u, v] = pick_best_k_gcca(data);
                    curr_filename = strcat(save_folder, '/', num2str(itr), '.mat');
                    save(curr_filename, 'u', 'v');
                end
            end
        end
    end
toc   
    
%% Load files and run 1-GCCA based

elseif strcmp(mode, 'no-prior') 
    tic

    n_settings = [1000]; 
    p_settings = [100];  
    q_settings = [100];
    degree_settings = [5, 10, 25, 50];
    sigma_settings = [0.5, 0.75];

    for setting_idx = 1
        n = n_settings(setting_idx);
        p = p_settings(setting_idx);
        q = q_settings(setting_idx);
        for degree = degree_settings
            for sigma_factor = sigma_settings
                disp(degree)
                disp(sigma_factor)
                curr_folder = strcat(load_file_prefix, num2str(degree), '_', num2str(sigma_factor*100));
                save_folder = strcat(save_file_prefix, num2str(degree), '_', num2str(sigma_factor*100), '_no_prior');
                mkdir(save_folder);
                for itr = 1:25
                    curr_filename = strcat(curr_folder, '/', num2str(itr), '.mat');
                    load(curr_filename);
                    data = struct('X_train', X_train', ...
                                  'Y_train', Y_train', ...
                                  'X_valid', X_valid', ...
                                  'Y_valid', Y_valid', ...
                                  'mode', mode);
                    [u, v] = pick_best_k_gcca(data);
                    
                    curr_filename = strcat(save_folder, '/', num2str(itr), '.mat');
                    save(curr_filename, 'u', 'v');
                end
            end
        end
    end

    toc
end
end