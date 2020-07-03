function show_tracking(image, image_index, trajectories, frame_number_threshold)
    % Show all the trajectories(detection boxes and corresponding previous path) in one image.
    % Image is in the image matrix, and trajectories are 8*N cells.

    imshow(image);
    hold on;
    
    for i=1:length(trajectories)
        curr_trj = trajectories(:,i);
        indices = curr_trj{1};
        if length(indices) > frame_number_threshold % Filt the trajectories with only short appearance
            if ismember(image_index, indices) % Check if this vehicle is in the frame
                color = curr_trj{5};
                last_det = curr_trj{2}(curr_trj{2}(:,1) == image_index,:);
                x = last_det(3);
                y = last_det(4);
                w = last_det(5);
                h = last_det(6);
                rectangle('Position', [x y w h], 'EdgeColor', color, 'LineWidth', 1, 'LineStyle', '-');
                
                % Emphasize the first 3 frames of a trajectory
                if find(indices == image_index) == 1 % red
                    text(x, y-size(image,1)*0.01, sprintf('%d', i), 'BackgroundColor', [.9 .3 .1], 'FontSize', 8); 
                elseif find(indices == image_index) == 2 % purple
                    text(x, y-size(image,1)*0.01, sprintf('%d', i), 'BackgroundColor', [.9 .3 .9], 'FontSize', 8); 
                elseif find(indices == image_index) == 3 % blue
                    text(x, y-size(image,1)*0.01, sprintf('%d', i), 'BackgroundColor', [.3 .6 .9], 'FontSize', 8); 
                else
                    text(x, y-size(image,1)*0.01, sprintf('%d', i), 'BackgroundColor', [.7 .9 .7], 'FontSize', 8); 
                end
                
                % Plot the trajectory points
                curr_trj_frames = curr_trj{2}(curr_trj{2}(:,1) <= image_index, :);
                curr_trj_points = [curr_trj_frames(:,3) + curr_trj_frames(:,5) / 2, curr_trj_frames(:,4) + curr_trj_frames(:,6) / 2];
                plot_lines_as_patches(curr_trj_points(:,1), curr_trj_points(:,2), 'LineWidth', 1, 'edgecolor', color, 'edgealpha', 0.3);
            end
            hold on;
        end
    end
    
    hold off;
     
end
