function [trajectories, living_trj_indices] = initialize_new_trajectory(trajectories, living_trj_indices, temp_index, image_index, ...
                                                                        recent_dets, det_index, all_trj_living, cmp)
    % For a detection box that cannot match any existed trajectory, initialize a new trajectory.

    new_trj_index = size(trajectories,2) + 1;
    trajectories{1,new_trj_index} = image_index; % Save keys(image indices) 1*N
    trajectories{2,new_trj_index} = recent_dets{temp_index}(det_index,:);% Save det results(image indices) N*8
    trajectories{3,new_trj_index} = [0.0 0.0]; % Save instantaneous velocity of the object
    trajectories{4,new_trj_index} = [0.0 0.0]; % Save global velocity(frame 1 to n) of the object
    trajectories{5,new_trj_index} = cmp(mod(new_trj_index-1,length(cmp))+1,:); % Assign a color for visulization    
    trajectories{6,new_trj_index} = 1; % Indicate whether this trajectory is living
    
    if ~all_trj_living
        living_trj_indices = [living_trj_indices new_trj_index];
    end
    
end
