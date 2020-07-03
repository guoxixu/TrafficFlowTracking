function transform_detection_result_format(folder_name, original_det)
    % Modify the original detetction result file to standard detection file format.
    
    old_det_file = [folder_name '/' original_det];
    fid = fopen(old_det_file, 'r');
    total_frames = str2num(fgetl(fid));
    fgetl(fid);
    fgetl(fid);
    det_result = cell(1,total_frames);
    det_boxes_counts = zeros(1, total_frames);
    for i = 1:total_frames
        frame_info = fgetl(fid);
        frame_id_start = strfind(frame_info,'/');
        frame_id_start = frame_id_start(end) + 1;
        frame_id_end = strfind(frame_info,'.') - 1;
        frame_id = str2num(frame_info(frame_id_start:frame_id_end));
        num_det_boxes = sscanf(frame_info,'%d',7);
        det_boxes_counts(frame_id) = num_det_boxes;
        for j = 1:num_det_boxes
            det = strsplit(fgetl(fid));
            det_result{frame_id} = [det_result{frame_id};[frame_id -1 str2num(det{1}) str2num(det{2}) ...
                str2num(det{3}) - str2num(det{1}) str2num(det{4}) - str2num(det{2}) str2num(det{7}) -1 -1 -1]];
        end
        fgetl(fid);
    end
    fclose(fid);
    
    new_det_file = [folder_name '/dt.txt'];
    fid = fopen(new_det_file, 'a');
    for i = 1:total_frames
        for j = 1:det_boxes_counts(i)
            fprintf(fid,'%d,%d,%d,%d,%d,%d,%f,%d,%d,%d\n',det_result{i}(j,1),det_result{i}(j,2), ...
            round(det_result{i}(j,3)),round(det_result{i}(j,4)),round(det_result{i}(j,5)),round(det_result{i}(j,6)), ...
            det_result{i}(j,7),det_result{i}(j,8),det_result{i}(j,9),det_result{i}(j,10)); 
        end
    end
    fclose(fid);
    
end
