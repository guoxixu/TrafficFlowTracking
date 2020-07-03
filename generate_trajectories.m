function [trajectories, last_frame_index] = generate_trajectories(folder_name, memory_series_size, IOU_threshold, conf_threshold, loss_thresholds, lambda)
    % From a series of pictures and the detection result, find the trajectories of all vehicles.
    
    det_result = read_detection_file(folder_name); % N*8 matrix including all detection results
    recent_pic_series = cell(1, memory_series_size); % Temporarily save recent pictures
    recent_dets = cell(1, memory_series_size); % Temporarily save recent detection results
    recent_indices = zeros(1, memory_series_size); % Indicate the corresponding image indices
 
    number_of_frames = 0;
    trajectories = {};
    cmp = colormap;
    picdir = dir(folder_name);

    for i = 1:length(picdir)
        if strfind(picdir(i).name,'.jpg')
            number_of_frames = number_of_frames + 1;
            image_index = str2num(picdir(i).name(isstrprop(picdir(i).name,'digit')));
            image_name = [folder_name '/' picdir(i).name];
            [recent_pic_series, recent_dets, recent_indices] = read_one_picture(recent_pic_series, recent_dets, recent_indices, ...
                                                                                memory_series_size, image_name, image_index, ...
                                                                                det_result, IOU_threshold, conf_threshold);
             
             if image_index <= memory_series_size
                 [trajectories, ~] = update_trajectories(trajectories, [], recent_pic_series, recent_indices, recent_dets, ...
                                                         cmp, image_index, image_index, loss_thresholds, lambda);
                 if image_index == memory_series_size
                     living_trj_indices = 1:length(trajectories);
                 end
             else
                 [trajectories, living_trj_indices] = update_trajectories(trajectories, living_trj_indices, recent_pic_series, recent_indices, recent_dets, ...
                                                                          cmp, memory_series_size, image_index, loss_thresholds, lambda);
                 
                 living_trj_indices_backup = living_trj_indices;
                 for k = living_trj_indices_backup
                     if image_index - trajectories{1,k}(end) >= memory_series_size - 1
                         trajectories{6,k} = 0;
                         living_trj_indices(living_trj_indices == k) = [];
                     end
                 end
             end
        end
    end

    last_frame_index = image_index;
    
end
