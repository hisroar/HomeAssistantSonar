A = [features_all, labels];
[m,n] = size([features_all labels]) ;
P = 0.70 ;
idx = randperm(m)  ;
Train= A(idx(1:round(P*m)),:) ; 
Test = A(idx(round(P*m)+1:end),:) ;
XTrain = Train(:,1:end-1);
YTrain = Train(:,end);

XTest = Test(:,1:end-1);
YTest = Test(:,end);

%SVM
%svmMdl = fitcsvm(XTrain, YTrain);
% svmCvMdl = crossval(svmMdl);
% svmError = kfoldLoss(svmCvMdl);
% accuracy = 1 - svmError;
% disp(accuracy)
%test_label = predict(svmMdl, XTest);
%disp(sum(YTest==test_label)/length(YTest));

mcSvmMdl = fitcecoc(XTrain,YTrain);
mcSvmTrainError = resubLoss(mcSvmMdl);
mcSvmTrainAcc = 1 - mcSvmTrainError;
mcSvmCvMdl = crossval(mcSvmMdl);
mcSvmCvError = kfoldLoss(mcSvmCvMdl);
mcSvmCvAcc = 1 - mcSvmCvError