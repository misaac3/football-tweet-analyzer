function runwordcloud
    data = readtable("tweets.csv", "TextType", "string");
    textdata = data.text;

    document = twitter_analysis(textdata);
    Bag1 = bagOfWords(document);
    Bag1 = removeInfrequentWords(Bag1,2);
    [Bag1,~] = removeEmptyDocuments(Bag1);

    textdata = lower(textdata);
    document2 = tokenizedDocument(textdata);
    document2 = erasePunctuation(document2);
    
    Bag2 = bagOfWords(document2);
    Bag2 = removeInfrequentWords(Bag2,2);
    [Bag2,~] = removeEmptyDocuments(Bag2);

    
    
    figure
    subplot(1,2,1)
    wordcloud(Bag1);
    title("Dataset 1")
    subplot(1,2,2)
    wordcloud(Bag2);
    title("Dataset 2")
end