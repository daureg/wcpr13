function [pred, proba] = predict_bayes_again(X, theta)
	N = size(X, 1);
	% add a unit feature $x_0 = 1$
	X=[ones(N,1) X];
	res=X*log(theta)'+(1-X(:,2:end))*log((1-theta(:,2:end)))';
	[m, index] = max(res, [], 2);
	pred = index - 1; % it assumes that classes are labeled 0, 1, ...
	%% use someting like to that to get real proba
	%% exp(res./repmat(norm(res,1,'rows'), 1, 2))
	proba = zeros(size(pred));
end
