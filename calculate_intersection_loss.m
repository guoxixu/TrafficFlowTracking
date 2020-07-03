function intersection_loss = calculate_intersection_loss(box1, box2, frame_interval)
    % Calculate the loss between two detection boxes(usually one from detection and the other from the last frame of a trajectory).
    % Usually the usage of this function is to match a detection box to a trajectory and append the former to the latter.
    % This loss function only applies to n & n+1 frames or n & n+2 frames(allowing one frame detection missing).
    % And we directly use (1 - IOU) as the loss function, since within 1 or 2 frames the box cannot move apart much.
    % For missing more than 1 frames detection box, use long_term_box_match_loss to estimate the long term loss.
    % box1 and box2 are [x y w h], frame_interval >= 1, intersection_loss ranges from 0 to 1 or intersection_loss = infinity, no unit.

    if frame_interval <= 2
        intersection_loss = 1 - calculate_IOU(box1, box2);
    else
        intersection_loss = inf; % Temporarily set to inf, and this loss will be replaced by long_term_box_match_loss.
    end
    
    if intersection_loss == 1
        intersection_loss = inf;
    end
    
end
