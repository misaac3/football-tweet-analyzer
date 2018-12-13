data = readtable("tweets.csv", "TextType", "string");
textdata = data.text;
% document = twitter_analysis(textdata);
cleanBag = bagOfWords(document);
cleanBag = removeInfrequentWords(cleanBag,2);
[cleanBag,idx] = removeEmptyDocuments(cleanBag);

Y = data.label;
Y(idx) = [];
X = cleanBag.Counts;

Model = fitctree(full(X) ,Y);

yeet = twitter_analysis("10 - Atlético de Madrid have drawn ten Nil-nil games in @ChampionsLeague, more than any other team in the competicion since 2013/2014 season, the first for Argentinian in the bench. Padlock");
Xt = addDocument(cleanBag, yeet);
label = predict(Model, full(Xt.Counts(end, 1:cleanBag.NumWords)))

