function read_picture_and_show_boxes(pic_name)
    % Read a picture and its corresponding json file(named pic_name.json) to show the mark or detection result.
    % For mark results: box: [91 223 225](cyan), guess: [184 53 186](purple), ignore: [238 231 117](yellow).
    
    pic = imread(pic_name);
    boxes = jsondecode(fileread([pic_name '.json']));
    imshow(pic);
    hold on
    
    for i = 1:length(boxes)
        box = boxes(i);
        switch char(box.properties.car2d_box_mulit_type)
            case 'box'
                c = [91 223 225] / 255;
            case 'guess'
                c = [184 53 186] / 255;
            case 'ignore'
                c = [238 231 117] / 255;
        end
        rectangle('Position', [box.x box.y box.w box.h], 'EdgeColor', c, 'LineWidth', 2, 'LineStyle', '-');
        hold on
    end
    hold off
    
end
