function filted_det_at_curr_image = filt_detection_boxes(det_at_curr_image, IOU_threshold, conf_threshold)
    % Read all detection boxes and only keep the boxes with confidence higher than the threshold_value, 
    % and filter them using non-maximum suppresion algorithm with IOU_threshold.
    
    % det_at_curr_image contains all information about detection bounding boxes:
    % <frame>, <id>, <bb_left>, <bb_top>, <bb_width>, <bb_height>, <conf>, <object_type>
    
    det_at_curr_image = det_at_curr_image(det_at_curr_image(:,7) > conf_threshold, :);
    valid_box_flags = suppress_non_maximum_detection_boxes(det_at_curr_image, IOU_threshold);
    filted_det_at_curr_image = det_at_curr_image(logical(valid_box_flags), :);

end
