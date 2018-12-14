
%% 1. Question 1-3
close all
delete(allchild(groot))

% Prepare data
data = readtable("tweets.csv", "TextType", "string");
textdata = data.text;
document = twitter_analysis(textdata);
cleanBag = bagOfWords(document);
cleanBag = removeInfrequentWords(cleanBag,2);
[cleanBag,idx] = removeEmptyDocuments(cleanBag);
Y = data.label;
Y(idx) = [];
X = full(cleanBag.Counts);

% Train model
numSplits = 20;
numTrees = 100;

Model = TreeBagger(numTrees, X, Y, 'OOBPrediction','on','Method', 'classification', 'PredictorNames', cleanBag.Vocabulary, 'MaxNumSplits',  numSplits );
oobErrorBaggedEnsemble = oobError(Model);
figID = figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
oobPredict(Model);

% View tree
view(Model.Trees{1},'mode','graph') % graphic description

%% Question 4a
lemmaBag = load ("lemma_cleanBag");
lemmaBag = lemmaBag.lemma_cleanBag;
figure
subplot(1,2,1)
wordcloud(cleanBag);
title("Dataset 1")
subplot(1,2,2)
wordcloud(lemmaBag);
title("Dataset 2")
%% Question 4b 
numSplits = 20;
numTrees = 49;

X1 = full(cleanBag.Counts);
X2 = full(lemmaBag.Counts);
Model_stem = TreeBagger(numTrees, X, Y, 'OOBPrediction','on','Method', 'classification', 'PredictorNames', cleanBag.Vocabulary, 'MaxNumSplits',  numSplits );
Model_lemma = TreeBagger(numTrees, X, Y, 'OOBPrediction','on','Method', 'classification', 'PredictorNames', cleanBag.Vocabulary, 'MaxNumSplits',  numSplits );
oobErrorBaggedEnsemble1 = oobError(Model_stem);
oobErrorBaggedEnsemble2 = oobError(Model_lemma);
figure
plot(oobErrorBaggedEnsemble1)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
title 'Model stemmed'
figure
plot(oobErrorBaggedEnsemble2)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
title 'Model lemmatized'
oobPredict(Model_stem);
oobPredict(Model_lemma);
    
%% Predict Tweet

% Don't believe the code works? Try it for yourself! We're pretty proud of
% it :)
close all
delete(allchild(groot))

numSplits = 20;
numTrees = 100;

Model = TreeBagger(numTrees, X, Y, 'OOBPrediction','on','Method', 'classification', 'PredictorNames', cleanBag.Vocabulary, 'MaxNumSplits',  numSplits );
oobErrorBaggedEnsemble = oobError(Model);
figID = figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
oobPredict(Model);

% View tree
view(Model.Trees{1},'mode','graph')         % graphic description
test_tweet = "arsenal beat tottenham ez";    
test_tweet_processed = twitter_analysis(test_tweet);
Xt = addDocument(cleanBag, test_tweet_processed);

label = predict(Model, full(Xt.Counts(end, 1:cleanBag.NumWords)));

disp('Tweet: ' + test_tweet)
if label{1,1} == '0'
    disp('Prediction: NFL')
else
    disp('Prediction: EPL')
end