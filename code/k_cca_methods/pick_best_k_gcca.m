function [u, v, best_struct] = pick_best_k_gcca(data)

%TODO fix the way we define the graphs and vary that properly
% from gcca_get_graph

best_correlation = -Inf;
best_struct = struct();

if ~isfield(data, 'L1')
    data.L1 = NaN;
end
if ~isfield(data, 'K')
    data.K = 1;
end

if data.K == 1

    for alpha1 = [10^(-1), 1, 10, 100, 1000]
        for alpha2 = [10^(-1), 1, 10, 100, 1000]
            for lambda1 = [10^(-1), 1, 10, 100, 1000]
                for lambda2 = [10^(-1), 1, 10, 100, 1000]
                    for beta1 = [1, 10, 100]
                        for beta2 = [1, 10, 100]                        
                            curr_struct = struct('alpha1', alpha1, ...
                                                'alpha2', alpha2, ...
                                                'lambda1', lambda1, ...
                                                'lambda2', lambda2, ...
                                                'beta1', beta1, ...
                                                'beta2', beta2, ...
                                                'mode', data.mode, ...
                                                'K', data.K, ...
                                                'L1', data.L1);
                            
                            [u, v] = k_gcca(data.X_train, data.Y_train, curr_struct);

                            if any(isnan(u)) || any(isnan(v))
                                continue
                            end
                            
                            x_variate = u'*data.X_valid';
                            y_variate = v'*data.Y_valid';
                            curr_correlation = x_variate*y_variate'/(sqrt(x_variate*x_variate')*sqrt(y_variate*y_variate'));

                            if curr_correlation > best_correlation
                                best_correlation = curr_correlation;
                                best_struct = curr_struct;
                            end
                        end
                    end
                end
            end
        end
    end
else
    
    if isfield(data, 'best_struct')
        best_struct = data.best_struct;
        best_struct.K = 100;
    end
end

u(:) = 0;
v(:) = 0;
if numel(fieldnames(best_struct)) ~= 0
    [u, v] = k_gcca(data.X_train, data.Y_train, best_struct);
end
