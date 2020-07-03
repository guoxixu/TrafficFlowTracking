function [trajectories, living_trj_indices] = update_trajectories(trajectories, living_trj_indices, recent_pic_series, recent_indices, recent_dets, cmp, temp_index, image_index, loss_thresholds, lambda)
    % Read a new frame and the corresponding detection results, update all the trajectories.

    curr_image = recent_pic_series{temp_index};
    curr_dets = recent_dets{temp_index};
    curr_det_indices = 1:size(curr_dets,1);
    curr_trj_indices = 1:length(trajectories);
    det_matched = zeros(1,length(curr_det_indices));
    trj_matched = zeros(1,length(curr_trj_indices));

    % The first round: match all the detect boxes with existed trajectories only using IOU information.
    if(~isempty(curr_det_indices))
        for j = curr_det_indices
            match_loss = zeros(1, length(trajectories));
            box_at_det = curr_dets(j, 3:6);

            if(~isempty(curr_trj_indices))
                for k = curr_trj_indices
                    curr_trj_last_index = trajectories{1,k}(end);
                    curr_trj_last_det = trajectories{2,k}(end,:);
                    box_at_trj = curr_trj_last_det(3:6);
                    frame_interval = image_index - curr_trj_last_index;
                    match_loss(k) = calculate_intersection_loss(box_at_det, box_at_trj, frame_interval);
                end

                [min_loss, min_loss_pos, second_min_loss, ~] = get_min_loss(match_loss);
                min_loss_index = min_loss_pos;

                if ((min_loss < 1 / loss_thresholds(1) && second_min_loss > 1 / loss_thresholds(1)) || ...
                    (min_loss < 1 / loss_thresholds(2) && second_min_loss > loss_thresholds(2) * min_loss)) && ~trj_matched(min_loss_index)
                    [trajectories, det_matched, trj_matched] = extend_trajectory(trajectories, det_matched, trj_matched, j, min_loss_index, curr_dets, image_index);
                end
            end
        end
    end

    % The second round: use relaxed matching conditions and complicated loss functions to match more. 
    [det_remaining_indices, trj_remaining_indices, det_remaining_length, trj_remaining_length] = update_match_status(det_matched, trj_matched);
    if det_remaining_length && trj_remaining_length
        for j = det_remaining_indices
            match_loss = zeros(1, trj_remaining_length);
            box_at_det = curr_dets(j, 3:6);
            box_at_det_pic = crop_image(curr_image, box_at_det);

            for k = trj_remaining_indices
                curr_trj_last_index = trajectories{1,k}(end);
                if any(recent_indices == curr_trj_last_index) % only check trajectories whose last frame is saved in memory
                    curr_trj_image = recent_pic_series{recent_indices == curr_trj_last_index};
                    curr_trj_last_det = trajectories{2,k}(end,:);
                    box_at_trj = curr_trj_last_det(3:6);
                    box_at_trj_pic = crop_image(curr_trj_image, box_at_trj);
                    frame_interval = image_index - curr_trj_last_index;
                    match_loss(trj_remaining_indices == k) = calculate_combined_loss(box_at_det, box_at_trj, box_at_det_pic, box_at_trj_pic, frame_interval);
                end
            end

            [min_loss, min_loss_pos, second_min_loss, second_min_loss_pos] = get_min_loss(match_loss);
            min_loss_index = trj_remaining_indices(min_loss_pos);
            IOU_at_min_loss = calculate_IOU(box_at_det, trajectories{2, trj_remaining_indices(min_loss_pos)}(3:6));
            IOU_at_second_min_loss = calculate_IOU(box_at_det, trajectories{2, trj_remaining_indices(second_min_loss_pos)}(3:6));

            if ((IOU_at_min_loss > IOU_at_second_min_loss) && (second_min_loss > loss_thresholds(3) * min_loss)) && ~trj_matched(min_loss_index)
                [trajectories, det_matched, trj_matched] = extend_trajectory(trajectories, det_matched, trj_matched, j, min_loss_index, curr_dets, image_index);
            end  
        end
    end

    % The third round: From the velocity, guess the expected position, and match trajectory with a neighbor detection.
    [det_remaining_indices, trj_remaining_indices, det_remaining_length, trj_remaining_length] = update_match_status(det_matched, trj_matched);
    if det_remaining_length && trj_remaining_length
        for j = det_remaining_indices
            match_loss = zeros(1, trj_remaining_length);
            box_at_det = curr_dets(j, 3:6);

            for k = trj_remaining_indices
                curr_trj_last_index = trajectories{1,k}(end);
                curr_trj_last_det = trajectories{2,k}(end,:);
                box_at_trj = curr_trj_last_det(3:6);

                guessed_velocity = lambda * trajectories{3,k} + (1 - lambda) * trajectories{4,k};
                frame_interval = image_index - curr_trj_last_index;
                guessed_box_at_trj = [box_at_trj(1:2) + guessed_velocity * frame_interval box_at_trj(3:4)];
                if (guessed_box_at_trj(1) < -1 || guessed_box_at_trj(1) + guessed_box_at_trj(3) > size(curr_image,2) + 1 || ...
                    guessed_box_at_trj(2) < -1 || guessed_box_at_trj(2) + guessed_box_at_trj(4) > size(curr_image,1) + 1)
                    match_loss(trj_remaining_indices == k) = inf;
                else
                    match_loss(trj_remaining_indices == k) = calculate_rectangle_distance(box_at_det, guessed_box_at_trj) + calculate_box_size_loss(box_at_det, guessed_box_at_trj);
                end
            end

            [min_loss, min_loss_pos, second_min_loss, second_min_loss_pos] = get_min_loss(match_loss);
            min_loss_index = trj_remaining_indices(min_loss_pos); 
            confidence = (min_loss_pos ~= second_min_loss_pos) && (second_min_loss < inf);

            if ((min_loss < 1) || (second_min_loss > loss_thresholds(4) * min_loss && confidence)) && ~trj_matched(min_loss_index)
                [trajectories, det_matched, trj_matched] = extend_trajectory(trajectories, det_matched, trj_matched, j, min_loss_index, curr_dets, image_index);
            end
        end
    end

    % The fourth round: For all unmatched detections, add a new trajectory.
    det_remaining_indices = find(det_matched == 0);
    det_remaining_length = length(det_remaining_indices);
    all_trj_living = temp_index == image_index; % indicate whether to renew living trajectory indices
    if det_remaining_length
        for j = det_remaining_indices
            [trajectories, living_trj_indices] = initialize_new_trajectory(trajectories, living_trj_indices, temp_index, image_index, recent_dets, j, all_trj_living, cmp);
        end
    end
    
end
