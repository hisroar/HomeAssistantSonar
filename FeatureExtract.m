% Function that extracts features for given data

% void FeatureExtract(str dataFolder, int label)
function FeatureExtract(dataFolder, featuresDir, label)

% Define variables
mainDir = pwd;
numFile = 9; % To be updated!! (9) *****
numTrials = 100; % To be updated!! (100) *****
numWindows = 8; % should be 8 *****

% If Trials directory does not exist, return error message and quit
TrialFolder = fullfile(mainDir,sprintf('/%s', dataFolder));
if ~isfolder(TrialFolder)
    fprintf('Error: The %s directory does not exist.\n', dataFolder);
    return;
end

% Create file for recording extracted features (named according to output mic #)
for num = 1:numFile
    fileNameFormat = fullfile(mainDir,featuresDir,sprintf('/features%d_format.txt', num-1));
    
    % Create new file if does not exist
    if ~isfile(fileNameFormat)
        fileIDFormat = fopen(fileNameFormat, 'w');

        % Print title row at top of file
        fprintf(fileIDFormat, 'Mean, Median, Std, Max, Skewness, Kurtosis, MFCC, LABEL\n\n');
        fclose(fileIDFormat);
    end
end

% For each trial, load the .wav files for feature extraction
for t = 1:numTrials
    trial_dir = fullfile(mainDir,dataFolder,num2str(t));
    
    % Loop through each audio file (9)
    for i = 1:numFile
        % Open file for recording extracted features (named according to output mic #)
        fileNameFormat = fullfile(mainDir,featuresDir,sprintf('/features%d_format.txt', i-1));
        fileIDFormat = fopen(fileNameFormat, 'a');
        fprintf(fileIDFormat, 'Trial #%d\n', t);
        % Unformatted version
        fileName = fullfile(mainDir,featuresDir,sprintf('/features%d.txt', i-1));
        fileID = fopen(fileName, 'a');

        % Create path to audio file for output(i-1).wav
        outputNum = sprintf('output%d.wav', i-1);
        audioFile = fullfile(trial_dir, outputNum);
        
        % Check that audio file is valid (TotalSamples != 0 and > 65500)
        info = audioinfo(audioFile);
        if info.TotalSamples == 0 || info.TotalSamples < 65500
            break; % Exit for loop -> go to next audio file number
        end
        
        % Read audio file -> output is data, sampling rate
        [data,rate] = audioread(audioFile);
        
        % Split data into windows (8)
        stepSize = ceil(length(data)/numWindows);
        index = 1;
        for win = 1:numWindows
            % Check that data index not exceeded -> assign to max index if exceeded
            if (index-1)+stepSize > length(data)
                iStart = index;
                iEnd = length(data);
            else
                iStart = index;
                iEnd = (index-1)+stepSize;
            end
            
            % Compute current data segment
            currData = data(iStart:iEnd);
            
            % Exract features and write to text file
            features = [mean(currData),median(currData),std(currData),max(currData),skewness(currData),kurtosis(currData)];
            for feature = features
                fprintf(fileIDFormat, '%f,', feature);
                fprintf(fileID, '%f,', feature);
            end
            
            % Computation for MFCC feature -> extract and write to text file
            const = 5;
            windowLength = ceil(size(currData,1)/const);
            overlapLength = rate*0.02; % default
            coeffs = mfcc(currData, rate, windowLength, overlapLength);
            for c_row = 1:size(coeffs,1)
                for c_col = 1:size(coeffs,2)
                    fprintf(fileIDFormat, '%f,', coeffs(c_row,c_col));
                    fprintf(fileID, '%f,', coeffs(c_row,c_col));
                end
            end
            
            % Write label value
            fprintf(fileIDFormat, '%d', label);
            fprintf(fileIDFormat, '\n');
            fprintf(fileID, '%d', label);
            fprintf(fileID, '\n');
            
            % Increment data index
            index = index + stepSize;
        end
        
        % End recording of extracted feature for given output file
        fprintf(fileIDFormat, '\n');
        fclose(fileIDFormat);
        fclose(fileID);
    end
end
