function W = tfidf(A)
	[N, M] = size(A);
	df = sum(A>0);
	d = log((N)*ones(1, M)./df);
	W = (A>0).*(1+log(A+1e-7)).*repmat(d, N, 1);
	tic
	bsxfun(@rdivide, W, sqrt(sum((W+1e-5).^2,1)));
	toc
end
