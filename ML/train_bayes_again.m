function [theta] = train_bayes_again(label, data)
	N = numel(label);
	K = numel(unique(label));
	d = size(data, 2);
	[count, ~] = hist(label, K);
	theta = zeros(K, d+1);
	theta(:,1) = count./N; %class priors
	i = 1;
	for c=reshape(unique(label), 1, K)
		this_class = label == c;
		theta(i, 2:end) = sum(data(this_class,:), 1) ./ sum(this_class);
		i = i + 1;
	end
	theta = min(max(theta,1e-8),1-1e-8); %remove 0 and 1 proba
end
