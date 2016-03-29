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
    % Obtain the frame
    vidFrame = readFrame(vidObj);
    % Create a new empty frame with the same size of the input frame
    target = logical(false(size(vidFrame,1), size(vidFrame,2)));
    % Show the frame
    figure(1); imshow(vidFrame); title('Draw a rectangle w/ mouse');
    % Get the rectangle drawn on the figure
    confirmed = false;
    while ~confirmed
        posRect = getrect;
        % Display the rectangle
        rectangle('Position', posRect);
        % Area drawn
        x_min = int16(posRect(1));
        x_max = int16(posRect(1) + posRect(3));
        y_min = int16(posRect(2));
        y_max = int16(posRect(2) + posRect(4));
        target(y_min:y_max, x_min:x_max) = true; 
        annotation(:,:,frameNum) = target;
        % Show the new image
%         figure(2); imshow(target);
        figure(3); imshow(vidFrame(y_min:y_max, x_min:x_max)); title('Selected Region');
        button = questdlg('Do you want to save it the frame?','Confirmation')
        if isempty(button)
            str = 'Yes';
            save(fileToSave, 'annotation');
            frameNum = frameNum + 1;
            close(3);
            confirmed = true;
        else          
            close(3);
        end
    end
end
