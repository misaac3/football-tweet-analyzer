data = readtable("tweets.csv", "TextType", "string");
textdata = data.text;
document = twitter_analysis(textdata);
cleanBag = bagOfWords(document);
cleanBag = removeInfrequentWords(cleanBag,2);
[cleanBag,idx] = removeEmptyDocuments(cleanBag);

Y = data.label;
Y(idx) = [];
X = full(cleanBag.Counts);

% MdlDefault = fitctree(X,Y,'CrossVal','on');
Model = TreeBagger(50, X, Y, 'OOBPrediction','on','Method', 'classification');
oobErrorBaggedEnsemble = oobError(Model);
figID = figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
print(figID, '-dpdf', sprintf('randomforest_errorplot_%s.pdf', date));
oobPredict(Model);
% view trees
% view(Model.Trees{1},'mode','graph') % graphic description

yeet = twitter_analysis("Top 3 Most IMPROBABLE Catches of Week 14! http://on.nfl.com/391pnw  @NextGenStats (by @MyStraightTalk)");
Xt = addDocument(cleanBag, yeet);
label = predict(Model, full(Xt.Counts(end, 1:cleanBag.NumWords)))

