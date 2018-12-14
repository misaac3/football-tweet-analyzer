close all
delete(allchild(groot))

data = readtable("tweets.csv", "TextType", "string");
textdata = data.text;
document = twitter_analysis(textdata);
cleanBag = bagOfWords(document);
cleanBag = removeInfrequentWords(cleanBag,2);
[cleanBag,idx] = removeEmptyDocuments(cleanBag);

Y = data.label;
Y(idx) = [];
X = full(cleanBag.Counts);

numSplits = 10;
Model = TreeBagger(15, X, Y, 'OOBPrediction','on','Method', 'classification', 'PredictorNames', cleanBag.Vocabulary, 'MaxNumSplits',  numSplits );
oobErrorBaggedEnsemble = oobError(Model);
figID = figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
print(figID, '-dpdf', sprintf('randomforest_errorplot_%s.pdf', date));
oobPredict(Model);
% view trees

view(Model.Trees{1},'mode','graph') % graphic description

test_tweet = "arsenal beat manchester city";
test_tweet_processed = twitter_analysis(test_tweet);
Xt = addDocument(cleanBag, test_tweet_processed);

label = predict(Model, full(Xt.Counts(end, 1:cleanBag.NumWords)));

disp('Tweet: ' + test_tweet)
if label{1,1} == '0'
    disp('Prediction: NFL')
else
    disp('Prediction: EPL')
end

