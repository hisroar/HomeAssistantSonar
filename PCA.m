S = cov(features_unpruned);
e = eig(S);
[V,D,W] = eig(S);

[e_desc, e_idx] = sort(e, 'descend');

V_desc = V(:,e_idx);

M = 100;
features_pca = features_unpruned * V_desc(:,1:M);

bagMdl = fitcensemble(features_pca, labels, 'Method', 'Bag');
bagCvMdl = crossval(bagMdl);
bagError = kfoldLoss(bagCvMdl);
accuracy = 1 - bagError;
disp(accuracy);