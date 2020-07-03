function make_detection_video(folder_name, is_save, frame_rate, IOU_threshold, conf_threshold)
    % Use the pictures(file names are index(start from 1).jpg) in the folder and the detection file(named 'dt.txt')
    % to show and make(if is_save == 1) the video('dt.avi') with frame_rate, showing the detection results.
    % Only choose the detection boxes with higher confidence than threshold_value, and apply non-max suppression.
    
    % Detection file contains all information about detection boxes:
    % <frame>, <id>, <bb_left>, <bb_top>, <bb_width>, <bb_height>, <conf>, <object_type>, <is_trunc>, <is_occu>
    
    detfile = [folder_name '/dt.txt'];
    fid = fopen(detfile, 'r');
    C = textscan(fid, '%f %f %f %f %f %f %f %f %f %f', 'Delimiter', ',');
    fclose(fid);
    det_result = [C{1} C{2} C{3} C{4} C{5} C{6} C{7} C{8}];
    close all;
    frame = figure();
    
    if is_save
        output_video_name =[folder_name '/dt.avi'];
        output_video = VideoWriter(output_video_name);
        output_video.FrameRate = frame_rate;
        open(output_video);
        fprintf('Will save detection video %s/dt.avi.\n', folder_name);
    end
    
    picdir = dir(folder_name);
    for i = 1:length(picdir)
        if strfind(picdir(i).name,'.jpg')
            curr_image = imread([folder_name '/' picdir(i).name]);
            image_index = str2num(picdir(i).name(isstrprop(picdir(i).name,'digit')));
            det_at_curr_image = det_result(det_result(:,1) == image_index,:);
            filted_det_at_curr_image = filt_detection_boxes(det_at_curr_image, IOU_threshold, conf_threshold);
            show_detection(curr_image, filted_det_at_curr_image);
            if is_save
                writeVideo(output_video, getframe(frame));
            end
        end
    end
    
    if is_save
        close(output_video);
        fprintf('Save detection video %s/dt.avi finished.\n', folder_name);
    end
            
end
