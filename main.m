data = readtable("tweets.csv", "TextType", "string");
textdata = data.text;

document = twitter_analysis(textdata);

cleanBag = bagOfWords(document);
cleanBag = removeInfrequentWords(cleanBag,2);
