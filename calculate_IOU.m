function IOU = calculate_IOU(rectangle1, rectangle2)
    % Rectangles are represented as [x, y, w, h], ([left, top, right-left, bottom-top])
    % where x and y are the coordinates of the top-left corner point.
    % Return: normalized IOU (A¡ÉB / A¡ÈB), ranges from 0 to 1, with no unit.
    
    inter_minx = max(rectangle1(1), rectangle2(1));
    inter_miny = max(rectangle1(2), rectangle2(2));
    inter_maxx = min(rectangle1(1) + rectangle1(3), rectangle2(1) + rectangle2(3));
    inter_maxy = min(rectangle1(2) + rectangle1(4), rectangle2(2) + rectangle2(4));
    
    if(inter_minx < inter_maxx && inter_miny < inter_maxy)
        A_and_B = (inter_maxx - inter_minx) * (inter_maxy - inter_miny);
        A_or_B = rectangle1(3) * rectangle1(4) + rectangle2(3) * rectangle2(4) - A_and_B;
        IOU = A_and_B / A_or_B;
    else
        IOU = 0;
    end
    
end
