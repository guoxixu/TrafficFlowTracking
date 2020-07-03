function det_result = read_detection_file(folder_name)
    % Read the dt.txt in folder_name to detection results matrix.
    
    det_file = [folder_name '/dt.txt'];
    fid = fopen(det_file, 'r');
    dets = textscan(fid, '%f %f %f %f %f %f %f %f %f %f', 'Delimiter', ',');
    fclose(fid);
    det_result = [dets{1} dets{2} dets{3} dets{4} dets{5} dets{6} dets{7} dets{8}];
     
end
