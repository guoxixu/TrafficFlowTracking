function [min_loss, min_loss_pos, second_min_loss, second_min_loss_pos] = get_min_loss(match_loss)
    % Get the minimum and second minimum loss and their positions in the loss vector.
    
    [min_loss,min_loss_pos] = min(match_loss);
    match_loss(min_loss_pos) = inf;
    [second_min_loss,second_min_loss_pos] = min(match_loss);
    
end
