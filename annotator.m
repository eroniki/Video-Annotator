%%% Simple video annotation tool
%%% Murat Ambarkutuk
%%% 03/28/2016
%%% Virginia Tech
%% Clear everything
clc; clear all; close all;
%% Create a video reader object
% If this line crashes the script, 
% it is likely to result from a missing G-Streamer plugin or G-Streamer
% itself; most likely missing plugin: gstreamer0.10-ffmpeg plugin 
fileName = '../data/ardrone_fixed_objects/video.mp4';
fileToSave = [fileName,'.mat'];
vidObj = VideoReader(fileName);
%% Loop over for each frame
frameNum = 1;
while hasFrame(vidObj)
%     frameNum
    % Obtain the frame
    vidFrame = readFrame(vidObj);
    % Extract HoG features for the frame
    % Create a new empty frame with the same size of the input frame
    maskCumulative = logical(false(size(vidFrame,1), size(vidFrame,2)));
    % Show the frame
    figure(1); imshow(vidFrame); title('Draw a rectangle w/ mouse');
    % Get the rectangle drawn on the figure
    confirmed = false
    k = 1;
    while ~confirmed    
        posRect = getrect;
        % Display the rectangle
        rectangle('Position', posRect);
        % Area drawn
        x_min = int16(posRect(1));
        x_max = int16(posRect(1) + posRect(3));
        y_min = int16(posRect(2));
        y_max = int16(posRect(2) + posRect(4));
        maskCumulative(y_min:y_max, x_min:x_max) = true; 

        annotation.frame(frameNum).maskCumulative = maskCumulative;

        annotation.frame(frameNum).targetIndividual(k).mask = logical(false(size(vidFrame,1), size(vidFrame,2)));
        annotation.frame(frameNum).targetIndividual(k).mask(y_min:y_max, x_min:x_max) = true; 

        annotation.frame(frameNum).targetIndividual(k).id = inputdlg('Please type the target type', 'Type'); 
        annotation.frame(frameNum).targetIndividual(k).targetRGB = imresize(vidFrame(y_min:y_max, x_min:x_max), [50, 50]);

        [annotation.frame(frameNum).targetIndividual(k).features, annotation.frame(frameNum).targetIndividual(k).hogVisualization] = extractHOGFeatures(annotation.frame(frameNum).targetIndividual(k).targetRGB);
        size(annotation.frame(frameNum).targetIndividual(k).features) 
        figure(2); imshow(maskCumulative);
        figure(3); imshow(vidFrame(y_min:y_max, x_min:x_max)); title('Selected Region');
        figure(4); plot(annotation.frame(frameNum).targetIndividual(k).hogVisualization);
        button = questdlg('Do you want to save it the frame?','Confirmation', 'Add more', 'Yes', 'No', ' ')

        if strcmp(button,'Yes')
            save(fileToSave, 'annotation');
            frameNum = frameNum + 1;
            confirmed = true;
        elseif strcmp(button,'No')
            close(2);
            close(3);
            close(4);
            continue;
        else
            k = k+1;
        end
        % Show the new image
        close(2);
        close(3);
        close(4);
    end
end
