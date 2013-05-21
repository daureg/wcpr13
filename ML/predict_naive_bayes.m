% Given a test set data and K discriminant function, return the most probable
% class of each sample in the index vector.
function [pred, proba] = predict_naive_bayes(data, allg)
	N=size(data, 1);
	K=size(allg, 1);
	k=size(allg, 2);
	% add a unit feature $x_0 = 1$
	X=[ones(N,1) data];
	[m, index] = max(X*allg', [], 2);
	% the classes are labeled from 0 to K-1 so remove 1
	proba = m; %INCORRECT
	pred = index - 1;
end
