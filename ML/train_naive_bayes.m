% Estimates normal parameters for each dimension of data and learn a
% linear discriminant function $g_i$ for each class. $\alpha$ and $\beta$ are
% regularization parameters. Return:
% all_g : a K by k matrix which holds the w_i vector use in g_i for all the classes
% sigmas : an array of the covariance matrix of each class
function [all_g, sigmas] = train_naive_bayes(label, data, alpha, beta)
	N=numel(label);
	K=numel(unique(label));
	k=size(data,2);
	X=data;
	[count, ~]=hist(label, K);
	prior = count./N;
	all_g = zeros(K,k+1);
	sigmas=zeros(k,k,K);
	sigma=zeros(k,k);
	s=mean(std(X));
	for c=1:K
		sigmas(:,:,c) = count(c)*cov(zscore(X(label==(c-1),:)));
		sigma += sigmas(:,:,c);
	end
	sinv = inv(sigma);
	sfinal=zeros(k,k);
	for c=1:K
		% $\alpha$ and $\beta$ control how each model of the covariance matrix
		% (shared hyperspheric, shared hyperellipsoid or differentiated
		% hyperellipsoid) will influence the final result. They can of course be
		% found by cross validation.
		sfinal = alpha*s.*eye(k) + beta.*sigma +(1-alpha-beta).*sigmas(:,:,c);
		sinv=inv(sfinal);
		mc = mean(X(label==(c-1),:));
		wi = sinv*mc';
		% Obviously, this empirical value should not be here but otherwise,
		% log(prior(c)) is too large compared to the $w_i$ and the model always
		% predicts the class with the greatest prior, which is not very efficient.
		wi0 = -0.5*mc*sinv*mc';% + log(prior(c))/36500;
		all_g(c,:) = [wi0 wi'];
	end
end
