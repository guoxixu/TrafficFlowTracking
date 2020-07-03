function show_single_trajectory(trajectory, folder_name)
    % Show a single trajectory(7*1 cells) based on the tracking result.
    
    frame_indices = trajectory{1}; 
    last_frame_index = frame_indices(end);
    color = trajectory{5};
    figure();
    imshow([folder_name '/' sprintf('%07d',last_frame_index) '.jpg'])
    hold on;
    
    for i = 1:length(frame_indices)
        curr_det = trajectory{2}(i,:);
        rectangle('Position', [curr_det(3) curr_det(4) curr_det(5) curr_det(6)],'EdgeColor', color, 'LineWidth', 1, 'LineStyle', '-');
        scatter(curr_det(3) + curr_det(5) / 2, curr_det(4) + curr_det(6), 600, '.');
        text(curr_det(3), curr_det(4), sprintf('%d', frame_indices(i)), 'BackgroundColor', [.7 .9 .7], 'FontSize', 8);  
        
        trj_frames = trajectory{2};
        trj_points = [trj_frames(:,3) + trj_frames(:,5) / 2, trj_frames(:,4) + trj_frames(:,6)];
        plot_lines_as_patches(trj_points(:,1), trj_points(:,2), 'LineWidth', 1, 'edgecolor', color, 'edgealpha', 0.3);
        hold on;
    end
    hold off;
    
end
