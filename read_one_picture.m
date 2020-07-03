function [recent_pic_series, recent_dets, recent_indices] = read_one_picture(recent_pic_series, recent_dets, recent_indices, memory_series_size, new_pic_name, new_pic_index, det_result, IOU_threshold, conf_threshold)
    % Read the picture in new_pic_name to the cell recent_pic_series(with constant size memory_series_size)
    % which save the most recent N pictures, and save the corresponding detection results and index. 
    % If picture index exceeds the memory size, remove the oldest picture and corresponding records.
    
    if new_pic_index <= memory_series_size
        recent_pic_series{new_pic_index} = imread(new_pic_name);
        recent_dets{new_pic_index} = filt_detection_boxes(det_result(det_result(:,1) == new_pic_index,:), IOU_threshold, conf_threshold);
        recent_indices(new_pic_index) = new_pic_index;
    else
        recent_pic_series(1) = [];
        recent_pic_series{memory_series_size} = imread(new_pic_name);
        recent_dets(1) = [];
        recent_dets{memory_series_size} = filt_detection_boxes(det_result(det_result(:,1) == new_pic_index,:), IOU_threshold, conf_threshold);
        recent_indices = [recent_indices(2:end) new_pic_index];        
    end
    
end
