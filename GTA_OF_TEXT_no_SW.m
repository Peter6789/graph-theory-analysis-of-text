% obtain networks from sliding windows of multiple texts. 
% written by Peter Coppola, peter.koppola[at]gmail.com. Algorythm based on Mota et al.,
% 2014 and Mota et al., 2012.

%% Instructions
% In data1 insert a Nx1 string array (N being number of individual texts)
% Outputs a variable called weightedNetworks with one level
% weightedNetworks{N,1} gives all the windows formed for that specific text
% NOTE< this version does not have a sliding window algorythm built into
% it! 
%

data1(1,1) = 


%% and away we go?
% and away we go! 



% Preprocess the text data
% Replace apostrophes with empty string
cleanedDocuments = replace(data1, "'", "");
% Tokenize the document
cleanedDocuments = tokenizedDocument(cleanedDocuments);
% Convert all words to lowercase
cleanedDocuments = lower(cleanedDocuments);
% Remove punctuation
cleanedDocuments = erasePunctuation(cleanedDocuments);

% Join the cleaned documents with a delimiter of "_"
Preprocessed_delim = joinWords(cleanedDocuments, '_');
% Join the cleaned documents with a space delimiter
Preprocessed = joinWords(cleanedDocuments);


% Loop through each row in the data table
for n = 1:length(data1)
n
    %count number of words
    
    numWords = length(split(Preprocessed(n,1)));        

            myWords = split(Preprocessed(n,1));
            
            text_from_window=join(myWords);

            % Create a bag of words for the preprocessed text
            Pbag = bagOfWords(tokenizedDocument(text_from_window));


            % Create a square adjacency matrix of zeros with the number of words in the bag as the size
            Network = zeros(Pbag.NumWords, Pbag.NumWords);
            % Split the preprocessed text into words using "_" as the delimiter
            SPLit_DREAM = strsplit(text_from_window);
            % Iterate through each pair of adjacent words in the preprocessed text
            for Words = 1:(length(SPLit_DREAM) - 1)
                % Find the index of the current word in the bag of words
                ind = strcmp(SPLit_DREAM(1,Words), Pbag.Vocabulary);
                % Find the index of the next word in the bag of words
                ind2 = strcmp(SPLit_DREAM(1,Words+1), Pbag.Vocabulary);
                % Increment the value of the corresponding cell in the adjacency matrix
                Network(find(ind), find(ind2)) = Network(find(ind), find(ind2)) + 1;
            end
            % Store the weighted network in a cell array
            weightedNetworks{1,n} = Network;
           
            % Clear the Network variable for the next iteration

            clear Network
end
