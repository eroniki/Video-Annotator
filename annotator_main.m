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
fileName = '../data/DARPA_VIVID/eg_test01/egtest01/';
fileToSave = fileName;
isVideo = 0;
%% Loop over for each frame
if isVideo==1
    vidObj = VideoReader(fileName);
    frameNum = 1;
    while hasFrame(vidObj)
    %     frameNum
        % Obtain the frame
        frame = readFrame(vidObj);
        % Extract HoG features for the frame
        % Create a new empty frame with the same size of the input frame
        annotation.frame(frameNum) = annotator(frame);
        save([fileToSave,'.mat'], 'annotation');
        frameNum = frameNum + 1;        
    end
else
    files = dir(fileName);
    % Delete ".", ".." and the video file from the list
    frameNumber = numel(files)-2;
    for frameNum=1:frameNumber
        fileName_ = [fileName, 'frame', num2str(frameNum-1, '%05d') , '.jpg'];
        % Obtain the frame
        frame = imread(fileName_);
        % Extract HoG features for the frame
        % Create a new empty frame with the same size of the input frame
        annotation.frame(frameNum) = annotator(frame);
        save([fileToSave,'frame','.mat'], 'annotation');
        frameNum = frameNum + 1;        
    end
end