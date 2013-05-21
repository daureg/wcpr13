function [pred, proba] = predict_random(how_many, training, clever)
	proba = rand(1, how_many)';
	if clever
		estimator = numel(find(training==max(training)))/numel(training);
	else
		estimator = .5;
	end
	pred = double(proba<estimator);
end
