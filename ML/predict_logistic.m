%Predict the label of samples in X given θ (as class 1 if P(y=1| x, θ)>0.5)
function [pred, proba] = predict_logistic(theta, X)
m = size(X, 1);
X = [ones(m, 1) X];
proba = sigmoid(X * theta);
pred = proba>0.5;
end
