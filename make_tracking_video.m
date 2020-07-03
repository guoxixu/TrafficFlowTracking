function make_tracking_video(trajectories, frame_number_threshold, last_frame_index, folder_name, is_save, frame_rate)
    % Use the pictures(file names are index(start from 1).jpg) in the folder and the trajectories(8*N cells)
    % to show and make(if is_save == 1) the video('tracking.avi') with frame_rate, showing the tracking results.
    % trajectories cell matrix contains all the information about boxes and their relationship.
    
    frame = figure();
    
    if is_save 
        output_video_name =[folder_name '/tracking.avi'];
        output_video = VideoWriter(output_video_name);
        output_video.FrameRate = frame_rate;
        open(output_video);
        fprintf('Will save tracking video %s/tracking.avi.\n', folder_name);
    end
    
    picdir = dir(folder_name);
    for i = 1:length(picdir)
        if strfind(picdir(i).name,'.jpg')
            curr_image = imread([folder_name '/' picdir(i).name]);
            image_index = str2num(picdir(i).name(isstrprop(picdir(i).name,'digit')));
            if image_index <= last_frame_index
                show_tracking(curr_image, image_index, trajectories, frame_number_threshold);
                if is_save
                    writeVideo(output_video, getframe(frame));
                end
            end
        end
    end

    if is_save
        close(output_video);
        fprintf('Save tracking video %s/tracking.avi finished.\n', folder_name);
    end
    
end
