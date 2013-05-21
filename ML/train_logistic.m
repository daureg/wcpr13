% Given samples in X and their label in y ∈ {0,1}, return a parameter vector θ
% that maximize the likelihood of sigmoid(x*θ) being equal to P(y=1| x, θ).
% λ is a regularization parameter that prevent ||θ||² from being too large.
function [theta] = train_logistic(X, y, lambda)
[m, n] = size(X);
X = [ones(m, 1) X];
initial_theta = zeros(n + 1, 1);
options = optimset('GradObj', 'on', 'MaxIter', 50);
[theta] = fmincg (@(t)(lrCostFunction(t, X, (y == 1), lambda)), initial_theta, options);
end
