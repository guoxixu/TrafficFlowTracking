function filt_object(folder_name)
    % Filt object detection and groundtruth result, and only keep the 4+ wheel vehicles.
    % Category(column 8): 4 for car, 5 for van, 6 for truck, 9 for bus.
    
    det = csvread([folder_name '/dt.txt']);
    newdet = det((det(:,8) == 4 | det(:,8) == 5 | det(:,8) == 6 | det(:,8) == 9),:);
    csvwrite([folder_name '/dt.txt'], newdet);
    gt = csvread([folder_name '/gt.txt']);
    newgt = gt((gt(:,8) == 4 | gt(:,8) == 5 | gt(:,8) == 6 | gt(:,8) == 9),:);
    csvwrite([folder_name '/gt.txt'], newgt);
    
end
