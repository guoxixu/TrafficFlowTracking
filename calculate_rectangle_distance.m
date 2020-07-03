function distance = calculate_rectangle_distance(rectangle1, rectangle2)
    % Rectangles are represented as [x, y, w, h], ([left, top, right-left, bottom-top])
    % where x and y are the coordinates of the top-left corner point.
    % Return: Normalized distance between two centers of rectangles, range from 0 to infinity, with no unit.
    
    dx = abs((rectangle1(1) + rectangle1(3) / 2) - (rectangle2(1) + rectangle2(3) / 2));
    dy = abs((rectangle1(2) + rectangle1(4) / 2) - (rectangle2(2) + rectangle2(4) / 2));
    d = sqrt(dx^2 + dy^2);
    diagonal1 = sqrt(rectangle1(3) ^ 2 + rectangle1(4) ^ 2);
    diagonal2 = sqrt(rectangle2(3) ^ 2 + rectangle2(4) ^ 2);   
    distance = d / sqrt(diagonal1 * diagonal2); % Normalized with diagonals

end
