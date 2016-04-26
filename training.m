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
fileToRead = [fileName,'.mat'];

load(fileToRead, 'annotation');

nFrames = numel(annotation);
featureSpace = zeros(nFrames,numel(annotation(1).features));
labels = randi(nFrames, [1, nFrames])';
labelsString = [char(repmat(cellstr(['target']), [1, nFrames])'), num2str(labels)]
for i=1:nFrames
    featureSpace(i,:) = annotation(i).features;
end

mdl = fitcknn(featureSpace, labelsString,'NumNeighbors',2,...
    'NSMethod','exhaustive','Distance','minkowski',...
    'Standardize',1);

label = predict(mdl,featureSpace) 