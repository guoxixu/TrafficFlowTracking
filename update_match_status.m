function [det_remaining_indices, trj_remaining_indices, det_remaining_length, trj_remaining_length] =  update_match_status(det_matched, trj_matched)
    % Update remaining detection and trajectory indices information.
    
     det_remaining_indices = find(det_matched == 0);
     trj_remaining_indices = find(trj_matched == 0);
     det_remaining_length = length(det_remaining_indices);
     trj_remaining_length = length(trj_remaining_indices);

end
