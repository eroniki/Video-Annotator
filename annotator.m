clc; clear all; close all;

vidObj = VideoReader('video.mp4');
figure;
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
%     image(vidFrame, 'Parent', currAxes);
%     currAxes.Visible = 'off';
    figure(1); imshow(vidFrame);
    posRect = getrect;
    rectangle('Position', posRect);
    figure(2);
    pause;
end