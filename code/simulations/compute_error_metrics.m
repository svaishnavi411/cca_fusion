function [u_error, v_error, corr_error, freq_error] = compute_error_metrics(u, v, est_u, est_v, X, Y, L)

    u_error = cosine_distance(est_u, u);
    v_error = cosine_distance(est_v, v);
    
    x_variate = u'*X;
    y_variate = v'*Y;    
    true_corr = x_variate*y_variate'/(sqrt(x_variate*x_variate')*sqrt(y_variate*y_variate'));

    est_x_variate = est_u'*X;
    est_y_variate = est_v'*Y;    
    est_corr = est_x_variate*est_y_variate'/(sqrt(est_x_variate*est_x_variate')*sqrt(est_y_variate*est_y_variate'));

    corr_error = true_corr - est_corr;
    
    freqs = u' * L * u;
    est_freqs = est_u' * L * est_u;
        
    freq_error = abs(est_freqs - freqs) / freqs;
end

