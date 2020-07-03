function [trajectories, det_matched, trj_matched] = extend_trajectory(trajectories, det_matched, trj_matched, det_index, min_loss_index, curr_dets, image_index)
    % Extend a trajectory with new matching result, and update matching indicators.
    
    first_det = trajectories{2,min_loss_index}(1,:); % The first frame including the detection box
    old_last_det = trajectories{2,min_loss_index}(end,:); % The last but one frame
    new_last_det = curr_dets(det_index,:); % The last(newest) frame
    
    x_first = first_det(3) + first_det(5) / 2;
    x_old_last = old_last_det(3) + old_last_det(5) / 2;
    x_new_last = new_last_det(3) + new_last_det(5) / 2;
    y_first = first_det(4) + first_det(6) / 2;
    y_old_last = old_last_det(4) + old_last_det(6) / 2;
    y_new_last = new_last_det(4) + new_last_det(6) / 2;
    t_instantaneous = new_last_det(1) - old_last_det(1);
    t_global = new_last_det(1) - first_det(1);
    
    trajectories{1,min_loss_index} = [trajectories{1,min_loss_index}, image_index]; % Append the index to trajectory
    trajectories{2,min_loss_index} = [trajectories{2,min_loss_index}; new_last_det]; % Append the box to trajectory
    trajectories{3,min_loss_index} = [x_new_last - x_old_last, y_new_last - y_old_last] / t_instantaneous; % Renew instantaneous center velocity
    trajectories{4,min_loss_index} = [x_new_last - x_first, y_new_last - y_first] / t_global; % Renew global center velocity
    det_matched(det_index) = 1;
    trj_matched(min_loss_index) = 1;
                                 
end
