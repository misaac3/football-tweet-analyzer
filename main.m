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

% MdlDefault = fitctree(X,Y,'CrossVal','on');
numSplits = 10
Model = TreeBagger(50, X, Y, 'OOBPrediction','on','Method', 'classification', 'PredictorNames', cleanBag.Vocabulary, 'MaxNumSplits',  numSplits);
oobErrorBaggedEnsemble = oobError(Model);
figID = figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
print(figID, '-dpdf', sprintf('randomforest_errorplot_%s.pdf', date));
oobPredict(Model);
% view trees

view(Model.Trees{1},'mode','graph') % graphic description
view(Model.Trees{2},'mode','graph') % graphic description
view(Model.Trees{3},'mode','graph') % graphic description


yeet = twitter_analysis("The #Steelers are one win in 2018 from securing a non-losing record for the 15th consecutive year, dating back to 2004, which would be the second-longest active streak in the #NFL: NE 2001-18: 18 PIT 2004-17: 14 SEA 2012-18: 7 KC 2013-18: 6");
Xt = addDocument(cleanBag, yeet);
label = predict(Model, full(Xt.Counts(end, 1:cleanBag.NumWords)))
label_key = sprintf("1: EPL\n0: NFL")

