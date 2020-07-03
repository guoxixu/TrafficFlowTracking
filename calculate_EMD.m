function EMD = calculate_EMD(img1,img2)
    % Calculate the Earth Mover's Distance (Wasserstein Distance) between two images 
    % Based on their grayscale histogram. It's a measure of image similarity.
    % Return: Normalized color distribution distance from two images, ranges from 0 to 1, no unit.

    [count1,~]=imhist(rgb2gray(img1));
    [count2,~]=imhist(rgb2gray(img2));
    count1 = count1 / sum(count1);
    count2 = count2 / sum(count2);
    
    temp_dist = 0.0;
    total_dist = 0.0;
    for i = 1:256
        temp_dist = count1(i) - count2(i) + temp_dist;
        total_dist = total_dist + abs(temp_dist);
    end
    
    EMD = total_dist / 255; % since the max EMD is 255 without normalization

end
