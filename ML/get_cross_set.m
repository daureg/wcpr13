% Return training and the k th validation indices for a K-fold of indices
function [trset, valset] = get_cross_set(indices, K, i)
	l=numel(indices);
	each = int32(l/K);
	assert(i<=K, 'i is greater than K');
	valset = indices((i-1)*each+1:min(i*each,l));
	trset = setdiff(indices, valset);
end
