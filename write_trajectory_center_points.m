function write_trajectory_center_points(folder_name, trajectories)
    % Write the tracking center results to centerpoints.result in the folder_name.
    % In every line, the information is <frame_id object_id center_x center_y>.
    
    tracking_file = [folder_name '/centerpoints.result'];
    fid = fopen(tracking_file, 'a');
    for i = 1:size(trajectories, 2)
        curr_trajectory = trajectories{2, i};
        for j = 1:size(curr_trajectory, 1)
            fprintf(fid,'%d,%d,%d,%d\n',curr_trajectory(j,1), i, ...
                    round(curr_trajectory(j,3) + curr_trajectory(j,5) / 2), ...
                    round(curr_trajectory(j,4) + curr_trajectory(j,6) / 2)); 
        end
    end
    fclose(fid);
    
end
