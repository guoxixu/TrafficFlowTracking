function combined_loss = calculate_combined_loss(box1, box2, box1_pic, box2_pic, frame_interval)
    % Calculate the loss between two detection boxes(usually one from detection and the other from the last frame of a trajectory).
    % We also need to take into account the frame interval between two boxes, since a trajectory may be interrupted.
    % Usually the usage of this function is to match a detection box to a trajectory and append the former to the latter.
    % box1 and box2 are [x y w h], box1_pic and box2_pic are M*N*3 images, and frame_interval >= 1.
    % The function considers image content difference, box center distance and box edge length difference, and the loss is in no unit. 
    
    dist_loss = calculate_rectangle_distance(box1, box2) / frame_interval;
    box_size_loss = calculate_box_size_loss(box1, box2);
    pic_content_loss = calculate_EMD(box1_pic, box2_pic);
    combined_loss = (dist_loss + box_size_loss) * pic_content_loss;
    
end
