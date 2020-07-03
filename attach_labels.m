function attach_labels(folder_name, label_position, digits, fontsize)
    % Attach labels to each picture in the folder, with position [x, y] and fontsize, and labels are the image index.
    % Digits indicates how many digits in the label(e.g. if digits=4, 654.jpg will be attached label '0654').

    picdir = dir(folder_name);
    for i = 1:length(picdir)
        if strfind(picdir(i).name,'.jpg')
            curr_image = imread([folder_name '/' picdir(i).name]);
            image_index = str2num(picdir(i).name(isstrprop(picdir(i).name,'digit')));
            format = ['%0' num2str(digits) 'd'];
            new_image = insertText(curr_image, label_position, sprintf(format, image_index),  'FontSize', fontsize);
            imwrite(new_image,[folder_name '/' picdir(i).name]);
        end
    end

end
