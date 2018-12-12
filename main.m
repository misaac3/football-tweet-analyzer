NFLdata = readtable("NFL_tweets.csv", "TextType", "string");
EPLdata = readtable("EPL_tweets.csv", "TextType", "string");

NFLdata = NFLdata.text;
EPLdata = EPLdata.text;

nflDocument = twitter_analysis(NFLdata);
eplDocument = twitter_analysis(EPLdata);

cleanBagNFL = bagOfWords(nflDocument);
cleanBagEPL = bagOfWords(eplDocument);

cleanBagNFL = removeInfrequentWords(cleanBagNFL,2);
cleanBagEPL = removeInfrequentWords(cleanBagEPL,2);

figure
subplot(1,2,1)
wordcloud(cleanBagNFL);
title("NFL")
subplot(1,2,2)
wordcloud(cleanBagEPL);
title("EPL")