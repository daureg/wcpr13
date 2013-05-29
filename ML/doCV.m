function [C,theta]=doCV(nfold, method, distance, trait)
load('swm.mat');
nz=sum(full(wm)>0);
[N, M] = size(wm);
load('POS.mat');
general=1:6;
words=7:size(wm,2);
tpos=1+size(wm,2):size(wm,2)+size(POS,2);
tg = wm(:,general);
wm = double(wm(:,words));
wm = [full(tg) full(wm) POS];
%load('sparse_orig_wm.mat');


% words used in more than 5% of texts but less than 75%
irt=and(nz>=.03*N, nz<=0.90*N);
sum(irt);
tmp=find(irt~=0);tmp(1:10);
%features = [irt];
% size(irt)
% size(features)
% size(wm)
%features=[8:M];
%features=full(sum(wm,1)~=0);
tmp=randperm(size(wm,2));
% features=[tmp(1:800)];
features=[words tpos];
load('label.mat')
label = label(:,trait);
% if strcmpi(method, 'bayes')
% %     lenghty = and(wm(:,1)>000,wm(:,2)>00,wm(:,3)>0);
%     lenghty = 1:N;
%     sum(lenghty);
%     X = double(wm(lenghty, features));
% else
%     u,s,v = svds(double(wm(:,features)), 250);
%     X = u*s*v';%zscore(double(wm(:,features)));
% end
[u,s,v] = svds(double(wm(:,features)), 300);
X = zscore(u*s*v');%zscore(double(wm(:,features)));
% save('X250','X');
% load('X250.mat')
% X=X(:,features);
z=randperm(size(X,1));
pred = {};
proba = {};

if strcmpi(method, 'svm')
    gspace=logspace(-5,-4,1);
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
fakefold=5;
% for lambda = lspace
    for gamma=gspace
    for cost=cspace
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

    for j = 1:fakefold
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
                mlnb = NaiveBayes.fit(X(tr,:), label(tr),'dist','nm');
                [proba{j}, pred{j}] = mlnb.posterior(X(vl,:));
                %% [discrim] = train_bayes_again(label(tr), X(tr,:));
                %% [pred{j}, proba{j}] = predict_bayes_again(X(vl,:), discrim);
                ttime = toc;
            case 'knn'
                mdl = ClassificationKNN.fit(X(tr,:),label(tr),'Distance', distance, 'NumNeighbors', 5);
                % not a probabistic method, the proba is the number of k
                % nearest neighbors that have the selected class.
                [pred{j},proba{j}] = predict(mdl,X(vl,:));
                ttime = toc;
        end
        [a, p, r, f] = evaluate(pred{j}, gold_label);
        C = confusionmat(gold_label, pred{j});
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
    end
end
tmp
mean(tmp(1:fakefold,:))
std(tmp);
distance;
result;
end