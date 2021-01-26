function [u, v, best_struct] = pick_best_k_scca(data)

p = size(data.X_train, 1);
q = size(data.Y_train, 1);

best_correlation = -10;
best_struct = struct();

if ~isfield(data, 'K')
    data.K = 1;
end

if data.K == 1

    for lambda1 = 0.1:sqrt(p)/10:sqrt(p)
        for lambda2 = (0.1:sqrt(q)/10:sqrt(q))
            curr_struct = struct('lambda1', lambda1, ...
                                 'lambda2', lambda2, ...
                                 'K', 1);
            [u, v] = k_scca(data.X_train, data.Y_train, curr_struct);

            x_variate = u'*data.X_valid';
            y_variate = v'*data.Y_valid';

            curr_correlation = x_variate*y_variate'/(sqrt(x_variate*x_variate').*sqrt(y_variate*y_variate'));

            if curr_correlation > best_correlation
                best_correlation = curr_correlation;
                best_struct = curr_struct;
            end
        end
    end
    
else

    if isfield(data, 'best_struct')
        best_struct = data.best_struct;
        best_struct.K = 100;
    end
end

[u, v] = k_scca(data.X_train, data.Y_train, best_struct);

