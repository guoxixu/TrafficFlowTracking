function trajectories = post_process_trajectories(trajectories)
    % Modify the generated trajectories, including reconstruct segmented trajectories.
    
    for i = 1:length(trajectories)
        indices = trajectories{1,i};
        first_index = indices(1);
        last_index = indices(end);
        
        if last_index - first_index ~= length(indices) - 1
            new_indices = first_index:last_index;
            new_dets = [];
            for j = new_indices
                if ismember(j, indices)
                    new_dets = [new_dets;trajectories{2,i}(trajectories{2,i}(:,1)==j,:)];
                elseif ~ismember(j, new_dets(:,1))
                    last_det = new_dets(end,:);
                    future_det = trajectories{2,i}(find(trajectories{2,i}(:,1)==last_det(1)) + 1,:);
                    for k = 1:(future_det(1) - last_det(1) -1)
                        curr_index = last_det(1) + k;
                        xy = last_det(3:4) + (future_det(3:4) - last_det(3:4)) / (future_det(1) - last_det(1)) * k;
                        wh = last_det(5:6).* (future_det(5:6)./ last_det(5:6)).^(1 / (future_det(1) - last_det(1)) * k);
                        guessed_det = [curr_index -1 xy wh 0 last_det(8)];
                        new_dets = [new_dets; guessed_det];
                    end
                end
            end
            trajectories{1,i} = new_indices;
            trajectories{2,i} = new_dets;
        end      
    end
    
end
