% [Funct] Function to select most important features given feature matrix and return new (pruned) feature matrix

% matrix FeatureSelect(matrix feature_all, int numSelect)
function [feature_pruned] = FeatureSelect(feature_all, numSelect)

% Form feature/label matrices for feature selection
features = feature_all(:,1:size(feature_all,2)-1);
labels = feature_all(:,size(feature_all,2));

% Perform Relief-F algorithm to rank importance of features in decreasing order (initial attempt: k=10)
[ranks, weights] = relieff(features, labels, 10);

% Create new pruned feature matrix w/ numSelect # of most important features
feature_pruned = [];
for col = 1:numSelect
    % Horizontally concatenate feature column, corresponding to index given by rank(col)
    index = ranks(col);
    feature_pruned = [feature_pruned, features(:,index)];
end

% Append labels as last column to features_pruned matrix
feature_pruned = [feature_pruned, labels];
end
