% Input all config to directly get the trajectory video and tracking results.

close all;
clear;
clc;

folder_name = 'experiment/1'; % 1 to 4, for experiment usage
delete(fullfile(folder_name, 'tracking.avi'));
delete(fullfile(folder_name, 'tracking.result'));
delete(fullfile(folder_name, 'centerpoints.result'));

is_save = 1; % whether to save tracking results
frame_rate = 6; % number of frames per second
IOU_threshold = 0.6; % for non-maximum suppression algorithm
conf_threshold = 0.6; % ignore all detection boxes with confidence lower than this
memory_series_size = 40; % keep some pictures in the memory for comparison
frame_number_threshold = 10; % only keep trajectories with enough frames
loss_thresholds = [2, 3, 4, 5]; % for matching detection and trajectories
lambda = 0.9; % for calculating expected box positions

% export_pictures_from_video(video_name, interval, folder_name, label_position, digits, font_size)
% original_det = 'dt.txt';
% transform_detection_result_format(folder_name, original_det);
% attach_labels(folder_name, [1, 1], 3, 100);
% filt_object(folder_name);
% make_detection_video(folder_name, is_save, frame_rate, IOU_threshold, conf_threshold);
% make_groundtruth_video(folder_name, is_save, frame_rate);

[trajectories, last_frame_index] = generate_trajectories(folder_name, memory_series_size, IOU_threshold, conf_threshold, loss_thresholds, lambda);
trajectories = process_trajectories(trajectories);
make_tracking_video(trajectories, frame_number_threshold, last_frame_index, folder_name, is_save, frame_rate);
write_tracking_results(folder_name, trajectories);
write_trajectory_center_points(folder_name, trajectories);
close all;
clc;
