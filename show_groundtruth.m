function show_groundtruth(image, gt_at_curr_image, gt_result)
    % Show all groundtruth boxes and the previous trjectories in one image.
    % Image is in the image matrix, and detection results are in det_at_curr_image matrix.
    
    cmp = colormap();
    imshow(image);
    hold on;
    
    for i = 1:size(gt_at_curr_image,1)
        frame_id = gt_at_curr_image(i,1);
        obj_id = gt_at_curr_image(i,2);
        x = gt_at_curr_image(i,3);
        y = gt_at_curr_image(i,4);
        w = gt_at_curr_image(i,5);
        h = gt_at_curr_image(i,6);
        box_color = cmp(mod(obj_id, length(cmp)) + 1, :);
        rectangle('Position', [x y w h], 'EdgeColor', box_color, 'LineWidth', 1, 'LineStyle', '-');
        text(x, y-size(image,1)*0.01, sprintf('%d', obj_id), 'BackgroundColor', [.7 .9 .7], 'FontSize', 8); 

        trj_frames = gt_result(gt_result(:,1) <= frame_id & gt_result(:,2) == obj_id, :);
        trj_points = [trj_frames(:,3) + trj_frames(:,5) / 2, trj_frames(:,4) + trj_frames(:,6)];
        plot_lines_as_patches(trj_points(:,1), trj_points(:,2), 'LineWidth', 1, 'edgecolor', box_color, 'edgealpha', 0.3);
    end
    
    hold off
    
end
