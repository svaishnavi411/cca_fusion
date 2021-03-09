function test_1_gcca_on_simulated(mode)
%% This code is to run GCCA on the saved simulated data

base_dir = '/mnt/data0-nfs/vs5/repos/cca_fusion/';
addpath(strcat(base_dir, 'code/cca_methods/'))
addpath(strcat(base_dir, 'code/simulations/'))
addpath(strcat(base_dir, 'code/k_cca_methods/'))
addpath(strcat(base_dir, 'code/data_preprocessing/'))
addpath(strcat(base_dir, 'code/cca_methods/gcca/'))
addpath(strcat(base_dir, 'code/deflation_method/'))

load_file_prefix = strcat(base_dir, 'data/simulated/');
save_file_prefix = strcat(base_dir, 'results/simulation_gcca/');
save_file_name = strcat(save_file_prefix, strcat('results_gcca_', mode, '.txt'));

num_experiments = 1000;
T = table('Size', [num_experiments, 11], ...
        'VariableTypes', {'int16', 'int16', ... 
                          'int16', 'double', 'double', 'int16', ...
                          'double', 'double',  'double', ...
                          'double', 'string'}, ...
        'VariableNames', {'n', 'p', 'q', ...
                          'degree','noise_sigma', 'itr', ...
                          'u_error', 'v_error',  'corr_error', ...
                          'freq_error', 'method'});
k = 0;

%% Load files and run 1-GCCA based
tic

if strcmp(mode, 'prior1')
    suffix = '_prior';
elseif strcmp(mode, 'no-prior')
    suffix = '_no_prior';
else
    error('Not implemented');
end

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
            result_folder = strcat(save_file_prefix, num2str(degree), '_', num2str(sigma_factor*100), suffix);

            for itr = 1:25

                result_filename = strcat(result_folder, '/', num2str(itr), '.mat');
                load(result_filename);
                est_u = u;
                est_v = v;

                orig_filename = strcat(curr_folder, '/', num2str(itr), '.mat');
                load(orig_filename);

                [u_error, v_error, corr_error, freq_error] = compute_error_metrics(u, v, est_u, est_v, X_test, Y_test, L);
  
                temp_struct = [];
                temp_struct.n = n;
                temp_struct.p = p;
                temp_struct.q = q;
                temp_struct.degree = degree;
                temp_struct.noise_sigma = sigma_factor;
                temp_struct.itr = itr;
                temp_struct.u_error = u_error;
                temp_struct.v_error = v_error;
                temp_struct.corr_error = corr_error;
                temp_struct.freq_error = freq_error;
                temp_struct.method = strcat('GCCA', mode);
                
                k = k+1;
                T(k, :) = struct2table(temp_struct);
            end
            writetable(T(1:k, :), save_file_name)
            end
        end
    end
toc
end
   