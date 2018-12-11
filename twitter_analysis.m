filename = "2010clean.xlsx";
data = readtable(filename,'TextType','string');
textData = data.text;
cleanTextData = lower(textData);
cleanTextData = erase(cleanTextData, "#");

% Tokenize the text.
documents = tokenizedDocument(cleanTextData);

% Erase punctuation.
documents = erasePunctuation(documents);

% Remove a list of stop words.
documents = removeStopWords(documents);

% Remove words with 2 or fewer characters, and words with 15 or greater
% characters.
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,15);

% Lemmatize the words.
documents = addPartOfSpeechDetails(documents);
documents = normalizeWords(documents,'Style','lemma');
cleanBag = bagOfWords(documents).tfidf;
cleanBag = removeInfrequentWords(cleanBag,2);
[cleanBag,idx] = removeEmptyDocuments(cleanBag);

rawDocuments = tokenizedDocument(textData);
rawBag = bagOfWords(rawDocuments).tfidf;

figure
subplot(1,2,1)
wordcloud(rawBag);
title("Raw Data")
subplot(1,2,2)
wordcloud(cleanBag);
title("Clean Data")
