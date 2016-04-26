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
fileName = 'video.mp4';
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
    mask = logical(false(size(vidFrame,1), size(vidFrame,2)));
    % Show the frame
    figure(1); imshow(vidFrame); title('Draw a rectangle w/ mouse');
    % Get the rectangle drawn on the figure
    confirmed = false
    while ~confirmed
        posRect = getrect;
        % Display the rectangle
        rectangle('Position', posRect);
        % Area drawn
        x_min = int16(posRect(1));
        x_max = int16(posRect(1) + posRect(3));
        y_min = int16(posRect(2));
        y_max = int16(posRect(2) + posRect(4));
        mask(y_min:y_max, x_min:x_max) = true; 
        annotation(frameNum).mask = mask;
        annotation(frameNum).target = imresize(vidFrame(y_min:y_max, x_min:x_max), [50, 50]);
        [annotation(frameNum).features, annotation(frameNum).hogVisualization] = extractHOGFeatures(annotation(frameNum).target);
        size(annotation(frameNum).features) 
        % Show the new image
        figure(2); imshow(mask);
        figure(3); imshow(vidFrame(y_min:y_max, x_min:x_max)); title('Selected Region');
        figure(4); plot(annotation(frameNum).hogVisualization);
        button = questdlg('Do you want to save it the frame?','Confirmation')
        if strcmp(button,'Yes')
            save(fileToSave, 'annotation');
            frameNum = frameNum + 1;
            confirmed = true;
        end
        close(2);
        close(3);
        close(4);
    end
end
