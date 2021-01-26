function [X_train, Y_train, X_valid, Y_valid, X_test, Y_test, L, G, u, v] = simulate_data(n, p, q, ...
    num_eigvec, sigma_factor, valid_factor, test_factor)

%% Step 1: Simulating data

num_valid = ceil(valid_factor * n);
num_test = ceil(test_factor * n);
num_train = n - num_test - num_valid;

L = [];
G = [];

%% Constructing a fully connected component here. 

prob_edge = 1.25*log(p)/p;

% rng(42)
while 1
  A = rand(p, p) < prob_edge;
  A = triu(A,1);
  A = A + A';

  G = graph(A);
  L = laplacian(G);

  if max(G.conncomp) == 1
      break;
  end
end

[V, ~] = eig(full(L));
u = (rand(1, num_eigvec)* V(:, 2:(num_eigvec+1))')';
u = u ./ norm(u);

v = [3*ones(1, 10), -1.5*ones(1,10), ones(1,10), 2*ones(1,10), zeros(1,60)]';
abs_v = exp ( - abs(v - v') );
v = v ./ norm(v);

%% Generate the X and Y matrices from u and v

w_train = randn(num_train, 1);
X_train = u * w_train' + sigma_factor * randn(p, num_train);
Y_train = v * w_train' + sigma_factor * mvnrnd(zeros(1, q), abs_v, num_train)';

w_valid = randn(num_valid, 1);
X_valid = u * w_valid' + sigma_factor * randn(p, num_valid);
Y_valid = v * w_valid' + sigma_factor * mvnrnd(zeros(1, q), abs_v, num_valid)';

w_test = randn(num_test, 1);
X_test = u * w_test' + sigma_factor * randn(p, num_test);
Y_test = v * w_test' + sigma_factor * mvnrnd(zeros(1, q), abs_v, num_test)';

end

