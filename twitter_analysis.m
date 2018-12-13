function [documents] = twitter_analysis(textData)
load stopwords_list
% Convert the text data to lowercase.
cleanTextData = lower(textData);

% Tokenize the text.
documents = tokenizedDocument(cleanTextData);

% Erase punctuation.
documents = erasePunctuation(documents);

% Remove a list of stop words.
documents = removeWords(documents, stopwords_list);

% Remove words with 2 or fewer characters, and words with 15 or greater
% characters.
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,15);

%% Lemmatize data. 
%  To perform stemming, you must be on Matlab 2018b OR Matlab Online

documents = addPartOfSpeechDetails(documents);
documents = normalizeWords(documents,'Style','lemma');
end