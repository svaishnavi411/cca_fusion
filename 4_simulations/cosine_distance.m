function [cos_dist] = cosine_distance(x,y)
xy = dot(x,y);
if xy < 0
    xy = -xy;
end
cos_dist = 1 - abs(xy/(norm(x) * norm(y)));
end

