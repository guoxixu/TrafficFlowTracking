function make_groundtruth_video(folder_name, is_save, frame_rate)
    % Use the pictures(file names are %07d.jpg) in the folder and the groundtruth file(named 'gt.txt')
    % To show and make(if is_save == 1) the video('gt.avi') with frame_rate, showing the groundtruth results.
    
    % Groundtruth file contains all information about bounding boxes:
    % <frame>, <id>, <bb_left>, <bb_top>, <bb_width>, <bb_height>, <1>, <object_type>, <is_trunc>, <is_occu>
    
    gtfile = [folder_name '/gt.txt'];
    fid = fopen(gtfile, 'r');
    C = textscan(fid, '%f %f %f %f %f %f %f %f %f %f', 'Delimiter', ',');
    fclose(fid);
    gt_result = [C{1} C{2} C{3} C{4} C{5} C{6} C{7} C{8}];
    close all;
    frame = figure();
    
    if is_save
        output_video_name =[folder_name '/gt.avi'];
        output_video = VideoWriter(output_video_name);
        output_video.FrameRate = frame_rate;
        open(output_video);
        fprintf('Will save groundtruth video %s/gt.avi.\n', folder_name);
    end
    
    picdir = dir(folder_name);
    for i = 1:length(picdir)
        if strfind(picdir(i).name,'.jpg')
            curr_image = imread([folder_name '/' picdir(i).name]);
            image_index = str2num(picdir(i).name(isstrprop(picdir(i).name,'digit')));
            gt_at_curr_image = gt_result(gt_result(:,1) == image_index,:);
            show_groundtruth(curr_image, gt_at_curr_image, gt_result);
            if is_save
                writeVideo(output_video, getframe(frame));
            end
        end
    end

    if is_save
        close(output_video);
        fprintf('Save groundtruth video %s/gt.avi finished.\n', folder_name);
    end
    
end
