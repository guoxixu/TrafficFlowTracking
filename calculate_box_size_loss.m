function box_size_loss = calculate_box_size_loss(box1, box2)
    % Calculate the loss between two detection boxes(usually one from detection and the other from the last frame of a trajectory).
    % Usually the usage of this function is to match a detection box to a trajectory and append the former to the latter.
    % This loss function focuses on the length ratio and width ratio of two detection boxes.
    % box1 and box2 are [x y w h],  box_size_loss ranges from 0 to infinity, no unit.
    
    box_size_loss = abs(log(box1(3) / box2(3))) * abs(log(box1(4) / box2(4)));

end
