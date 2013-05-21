function [C] = confusionmat(gold, pred, pos)
pos = max(unique(gold));
neg = min(unique(gold));
tp = sum(and(pred==pos, gold==pos));
tn = sum(and(pred==neg, gold==neg));
fp = sum(and(pred==pos, gold==neg));
fn = sum(and(pred==neg, gold==pos));
C = [tn fp; fn tp];
end
