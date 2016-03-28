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
vidObj = VideoReader('video.mp4');
%% Loop over for each frame
while hasFrame(vidObj)
    % Obtain the frame
    vidFrame = readFrame(vidObj);
    % Create a new empty frame with the same size of the input frame
    target = zeros(size(vidFrame,1), size(vidFrame,2));
    % Show the frame
    figure(1); imshow(vidFrame);
    % Get the rectangle drawn on the figure
    posRect = getrect;
    % Display the rectangle
    rectangle('Position', posRect);
    figure(2);
    % Show the new image
    pause;
end