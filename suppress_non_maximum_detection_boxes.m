function valid_box_flags = suppress_non_maximum_detection_boxes(det_at_curr_image, IOU_threshold)
    % det_at_curr_image contains all information about detection bounding boxes:
    % <frame>, <id>, <bb_left>, <bb_top>, <bb_width>, <bb_height>, <conf>, <object_type>
    % Use non-maximum suppression algorithm to remove duplicate detection results.

    valid_box_flags = ones(size(det_at_curr_image,1),1); % Indicate whether to use the box
    for i = 1:length(valid_box_flags) - 1
        if valid_box_flags(i)
            for j = (i + 1):length(valid_box_flags)
                if valid_box_flags(j)
                    IOU = calculate_IOU(det_at_curr_image(i, 3:6), det_at_curr_image(j, 3:6));
                    if IOU > IOU_threshold
                        valid_box_flags(j) = 0;
                    end
                end
            end
        end
    end
    
end
