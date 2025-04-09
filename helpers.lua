function distance(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function circleCollision(x1,y1, r1, x2,y2, r2)
    local dist = distance(x1,y1, x2,y2)
    return dist <= (r1 + r2)
end