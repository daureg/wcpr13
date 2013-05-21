function [C,theta]=doCV(nfold, method, trait)
load('wm.mat');
[N, M] = size(wm);
nz=sum(full(wm)>0);
% words used in more than 5% of texts but less than 75%
irt=and(nz>=.001*N, nz<=.95*N);
sum(irt)
features = irt;
features=[8:size(wm,2)];
load('label.mat')
label = label(:,trait);
if strcmpi(method, 'bayes')
	lenghty = and(wm(:,1)>000,wm(:,2)>00,wm(:,3)>0);
	sum(lenghty)
	X = full(wm(lenghty, features)>0);
else
	X = zscore(wm(:,features));
end
z=randperm(size(X,1));
pred = {};
proba = {};

if strcmpi(method, 'svm')
    gspace=logspace(-5,-4,4);
    cspace=[15];%logspace(0,2,3);
    lspace = [1];
    numtests=numel(gspace)*numel(cspace);
else
    gspace=[0.015];
    cspace=[20];
    lspace = logspace(-5, -5, 1);
    numtests=numel(lspace);
end
gparams=zeros(numtests,1);
cparams=zeros(numtests,1);
result = zeros(numtests, 6);
i=1;
for lambda = lspace
    %% for gamma=gspace
    %% for cost=cspace
    tmp = zeros(nfold, 6);
    if strcmpi(method, 'svm')
        if exist('gamma', 'var') == 0
            gamma = gspace(1);
        end
        if exist('cost', 'var') == 0
            cost = cspace(1);
        end
        options=sprintf('-h 0 -m 1024 -g %.9f -c %.4f -q', gamma, cost)
    end
    
    for j = 1:nfold
        %j
        [tr, vl] = get_cross_set(z, nfold, j);
        numel(tr);
        numel(vl);
		gold_label = label(vl);
        tic;
        switch method
            case 'svm'
                model = svmtrain(double(label(tr)), full(X(tr,:)), options);
                [pred{j}, ~, proba{j}] = svmpredict(double(gold_label), full(X(vl,:)), model, '-b probability_estimates');
                ttime = toc;
            case 'logr'
                % B=glmfit(single(X{j}(tr,:)), [single(label{j}(tr)) ones(numel(tr),1)], 'binomial', 'link', 'logit');
                % proba{j}=sigmoid(B(1) + Xval{j}(vl,:) * (B(2:end)));
                % pred{j}=proba{j}>0.5;
                theta=train_logistic(X(tr,:), label(tr), 10*j*lambda);
                [pred{j}, proba{j}] = predict_logistic(theta, X(vl,:));
                ttime = toc;
            case 'random'
                [pred{j}, proba{j}] = predict_random(numel(gold_label), label(tr), true);
                ttime = toc;
			case 'bayes'
				mlnb = NaiveBayes(X(tr,:), label(tr));
				[proba{j}, pred{j}] = max(mlnb.posterior(X(vl,:), [], 2);
				%% [discrim] = train_bayes_again(label(tr), X(tr,:));
				%% [pred{j}, proba{j}] = predict_bayes_again(X(vl,:), discrim);
				ttime = toc;
        end
        [a, p, r, f] = evaluate(pred{j}, gold_label);
        C = confusionmat(gold_label, double(pred{j}));
        fp = C(1,2)/sum(C(1,:));
        tmp(j,:)=[a, p, r, f, fp, ttime];
    end
    %[x, y, t, auc] = perfcurve(gold_label{1}, proba{1}, 1);
    %plot(x(:,1), y(:,1));
    %save(strcat('result_',data_prefix,'_', method,'_',num2str(MIN_EMBED),'.mat'), 'tmp', 'x', 'y', 'auc');
    %% result(i,:)=mean(tmp)
    result(i,:)=tmp(1,:);
    %gparams(i)=gamma;
    %cparams(i)=cost;
    i = i + 1;
    %% end
end
tmp
mean(tmp)
result;
end
