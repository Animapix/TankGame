function newBullet(pX, pY, dx, dy, speed, range, owner)
    local b = {}	
    b.startX = pX
    b.startY = pY
    b.pX = pX
    b.pY = pY
    b.dX = dx
    b.dY = dy
    b.speed = speed or 1000
    b.range = range or 800
    b.isFree = false
    b.radius = 10
    b.damage = 50
    b.owner = owner or "player"

    b.update = function(dt)
        b.pX = b.pX + b.dX *  b.speed * dt
        b.pY = b.pY + b.dY *  b.speed * dt

        local dist = distance(b.startX,b.startY, b.pX,b.pY)
        if(dist >= b.range) then
            b.isFree = true
        end
    end

    b.draw = function()
        love.graphics.circle("fill", b.pX, b.pY , b.radius)
    end

    return b
end