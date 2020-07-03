function cropped_image = crop_image(original_image, rectangle)
    % Given an orignal image(M*N*3 matrix) and a rectangle bounding box([x y w h]), get the cropped image.
    % Usually used to get a single detected object.
    
    if rectangle(1) < 1
        rectangle(1) = 1;
    end
    if rectangle(2) < 1
        rectangle(2) = 1;
    end
    cropped_image = original_image(rectangle(2):rectangle(2) + rectangle(4), rectangle(1):rectangle(1) + rectangle(3), :);
    
end
