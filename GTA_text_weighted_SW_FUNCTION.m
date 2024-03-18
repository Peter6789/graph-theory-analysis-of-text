
function weightedNetworks = GTA_text_weighted_SW(data1, window2slide, SLIDE)
%data1(N,1) = your data. Nx1 string array of raw text
%window2slide = how big do you want your windows. E.g., including 30 words
%(as per paper). Accepts integer. Defaults to 30 if no value given. 
% SLIDE, defines the distance between each sliding window. Defaults to 1


% obtain networks from sliding windows of multiple texts. 

% written by Peter Coppola, peter.koppola[at]gmail.com. Algorythm based on Mota et al.,
% 2014 and Mota et al., 2012.

%% Instructions
% In data1(N,1) insert a Nx1 string array (N being number of individual texts)
% Outputs a variable called weightedNetworks with two levels
% weightedNetworks{N,1} gives all the windows formed for that specific text
%weigthtedNetworks{N,1}{windownumber}= gives the specific matrix for a
%specific window (i.e., windownumber), for a specific text (i.e., N) 

%LENGTH OF WINDOW; change this vsriable i.e., window2slide if you want bigger/smaller networks (note, if there are not enough words in a text, ...
% the code will input "not enough words" in weightedNetworks)



%Slide step; this is by how many words you want to slide the window in the sliding window alogorythm. 1 is, more or less, the least arbitrary. Note the whole point of sliding window is to ensure that the resulting networks are more or less comparable. See paper associated with this code for more details.  


  if isempty(window2slide)
     window2slide = 30;
    end


 if isempty(SLIDE)
     SLIDE = 1;
    end



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
    %find out how many windows per individual text you can obtain (sliding window)
    numWindows = floor((numWords  - window2slide ) / SLIDE) + 1;
    start_slide=1;
            end_slide=window2slide;
    if numWords<window2slide

        weightedNetworks{1,n} = 'not enough words';
    else
        for WIND =1: numWindows
            myWords = split(Preprocessed(n,1));
            
            text_from_window=join(myWords(start_slide:end_slide));

            % Create a bag of words for the preprocessed text
            Pbag = bagOfWords(tokenizedDocument(text_from_window));


            % Create a square adjacency matrix of zeros with the number of words in the bag as the size
            Network = zeros(Pbag.NumWords, Pbag.NumWords);
            % Split the preprocessed text into words using "_" as the delimiter
            SPLit_TXT = strsplit(text_from_window);
            % Iterate through each pair of adjacent words in the preprocessed text
            for Words = 1:(length(SPLit_TXT) - 1)
                % Find the index of the current word in the bag of words
                ind = strcmp(SPLit_TXT(1,Words), Pbag.Vocabulary);
                % Find the index of the next word in the bag of words
                ind2 = strcmp(SPLit_TXT(1,Words+1), Pbag.Vocabulary);
                % Increment the value of the corresponding cell in the adjacency matrix
                Network(find(ind), find(ind2)) = Network(find(ind), find(ind2)) + 1;
            end
            % Store the weighted network in a cell array
            weightedNetworks{1,n}{WIND} = Network;
           
            % Clear the Network variable for the next iteration
            %insert this at the end !! This moved the sliding window

            start_slide = start_slide + SLIDE;
            end_slide = end_slide+SLIDE;

            clear Network
        end
    end
end
end
