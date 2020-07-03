function export_pictures_from_video(video_name, interval, folder_name, label_position, digits, font_size)
    % Read a video, pick up frames with a specified interval to a folder, and attach labels to each image.

    v = VideoReader(video_name);
    n = v.NumberOfFrames;
    if ~exist(folder_name,'dir')
        mkdir(folder_name);
    end
    
    count = 0;
    for i = 1:interval:n
        count = count + 1;
        curr_image = v.read(i);
        image_name = sprintf(['%0' num2str(digits) 'd.jpg'], count);
        new_image = insertText(curr_image, label_position, sprintf(['%0' num2str(digits) 'd'], count), 'FontSize', font_size);
        imwrite(new_image,[folder_name '/' image_name]);
    end
    
end
