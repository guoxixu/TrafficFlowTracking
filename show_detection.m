function show_detection(image, det_at_curr_image)
    % Show all detection boxes in one image with higher confidence than the threshold.
    % Image is in the image matrix, and detection results are in det_at_curr_image matrix.

    imshow(image);
    hold on;
    
    for i = 1:size(det_at_curr_image,1)
        x = det_at_curr_image(i,3);
        y = det_at_curr_image(i,4);
        w = det_at_curr_image(i,5);
        h = det_at_curr_image(i,6);
        r = det_at_curr_image(i,7);
        rectangle('Position', [x y w h], 'EdgeColor', 'g', 'LineWidth', 1, 'LineStyle', '-');
        text(x, y-size(image,1)*0.01, sprintf('%.4f', r), 'BackgroundColor', [.7 .9 .7], 'FontSize', 8);    
    end

    hold off
    
end
