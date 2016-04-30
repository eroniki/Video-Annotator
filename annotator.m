function [frame_] = annotator(frame)
% Show the frame
figure(1); imshow(frame); title('Draw a rectangle w/ mouse');

% Get the rectangle drawn on the figure
maskCumulative = logical(false(size(frame,1), size(frame,2)));
    
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

    frame_.maskCumulative = maskCumulative;

    frame_.targetIndividual(k).mask = logical(false(size(frame,1), size(frame,2)));
    frame_.targetIndividual(k).mask(y_min:y_max, x_min:x_max) = true; 

    frame_.targetIndividual(k).id = inputdlg('Please type the target type', 'Type'); 
    frame_.targetIndividual(k).targetRGB = imresize(frame(y_min:y_max, x_min:x_max), [50, 50]);
    % Feature representation
    [frame_.targetIndividual(k).features, frame_.targetIndividual(k).hogVisualization] = extractHOGFeatures(frame_.targetIndividual(k).targetRGB);
    size(frame_.targetIndividual(k).features) 
    surfpoints = detectSURFFeatures(frame_.targetIndividual(k).targetRGB);
    surfpoints = surfpoints.selectStrongest(10);
    [f1, ~] = extractFeatures(frame_.targetIndividual(k).targetRGB, surfpoints);
    frame_.targetIndividual(k).features = [frame_.targetIndividual(k).features, f1(:)'];
    size(frame_.targetIndividual(k).features)

    figure(2); imshow(maskCumulative);
    figure(3); imshow(frame(y_min:y_max, x_min:x_max)); title('Selected Region');
    figure(4); plot(frame_.targetIndividual(k).hogVisualization);
    button = questdlg('Do you want to save it the frame?','Confirmation', 'Add more', 'Yes', 'No', ' ')

    if strcmp(button,'Yes')
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

