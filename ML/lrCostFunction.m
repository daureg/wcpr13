% Compute cost and gradient for logistic regression with regularization at point θ
function [J, grad] = lrCostFunction(theta, X, y, lambda)
% number of training examples
m = length(y);

h = sigmoid(X * theta);
% we dont wan't to regularize the bias term
thetaFiltered = [0; theta(2:end)];

costPositive = -y' * log(h);
costNegative =  (1 - y') * log(1 - h);
reg = (lambda / (2*m)) * (thetaFiltered' * thetaFiltered);

J = (1/m) * (costPositive - costNegative) + reg;
grad = (1/m) * (X' * (h - y)) + ((lambda / m) * thetaFiltered);
grad = grad(:);

end
