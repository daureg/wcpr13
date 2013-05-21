% Compute accuracy, precision, recall and F1 score for a binary classification.
function [acc, prec, rec, F1] = evaluate(pred, gold)
tp = sum(and(pred==1, gold==1));
tn = sum(and(pred==0, gold==0));
fp = sum(and(pred==1, gold==0));
fn = sum(and(pred==0, gold==1));
N = numel(gold);

acc = (tp+tn)/N;
prec = tp/(tp+fp);
rec = tp/(tp+fn);
F1 = 2*(prec*rec)/(prec+rec);
end
