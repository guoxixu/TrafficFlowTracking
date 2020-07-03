function write_tracking_results(folder_name, trajectories)
    % Write the tracking results to tracking.result in the folder_name.
    % In every line, the information is <frame_id object_id box_left box_top width height 1 1 0 0>.
    
    tracking_file = [folder_name '/tracking.result'];
    fid = fopen(tracking_file, 'a');
    for i = 1:size(trajectories, 2)
        curr_trajectory = trajectories{2, i};
        for j = 1:size(curr_trajectory, 1)
            fprintf(fid,'%d,%d,%d,%d,%d,%d,1,1,0,0\n',curr_trajectory(j,1), i, ...
                    round(curr_trajectory(j,3)), round(curr_trajectory(j,4)), ...
                    round(curr_trajectory(j,5)), round(curr_trajectory(j,6)));
        end
    end
    fclose(fid);
    
end
