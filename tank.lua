require("bullet")

local bodyImg = love.graphics.newImage("assets/images/tank/body.png")
local canonImg = love.graphics.newImage("assets/images/tank/canon.png")
local gunsImg = love.graphics.newImage("assets/images/tank/guns.png")
local shadowImg = love.graphics.newImage("assets/images/tank/shadow.png")
local tracksImg = love.graphics.newImage("assets/images/tank/tracks.png")
local turretImg = love.graphics.newImage("assets/images/tank/turret.png")


local offset = { x = bodyImg:getWidth() * .5 , y= bodyImg:getHeight() * .5 }
local tankAngle = 0
local rotationSpeed = 2
local direction = 0
local rotationDirection = 0
local position = { x = SCREEN_SIZE.width * .5, y =  SCREEN_SIZE.height * .5 }
local speed = 400

local turretAngle = 0
local firePoint = { x = 0, y = 0 }
local canonLenght = 100
local health = 100

local tank = {}
tank.radius = 50

tank.gameOverCallback = nil

tank.update = function(dt)
    if not (direction == 0) then
        local dx = math.cos(tankAngle) * speed * direction * dt
        local dy = math.sin(tankAngle) * speed * direction * dt
        position.x = position.x + dx
        position.y = position.y + dy
    end
    tankAngle = tankAngle - rotationSpeed * dt * rotationDirection
end

tank.move = function(dir)
    direction = dir
end

tank.rotate = function(dir)
    rotationDirection = dir
end

tank.aim = function(mouseX, mouseY)
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    turretAngle = math.atan2(dy, dx)
    firePoint.x = math.cos(turretAngle) * canonLenght + position.x
    firePoint.y = math.sin(turretAngle) * canonLenght + position.y
end

tank.fire = function()
    local dx =  math.cos(turretAngle)
    local dy =  math.sin(turretAngle)
    local b = newBullet(firePoint.x, firePoint.y, dx, dy)
    return b
end

tank.draw = function()
    love.graphics.setColor(1,1,1,0.4)
    love.graphics.draw(shadowImg, position.x , position.y , 0 , 1, 1, offset.x, offset.y)
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.draw(tracksImg, position.x , position.y , tankAngle , 1, 1, offset.x, offset.y)
    love.graphics.draw(bodyImg, position.x , position.y , tankAngle , 1, 1, offset.x, offset.y)

    love.graphics.draw(shadowImg, position.x , position.y , 0 , 1, 1, offset.x, offset.y)
    love.graphics.draw(turretImg, position.x , position.y , turretAngle , 1, 1, offset.x, offset.y)
    love.graphics.draw(canonImg, position.x , position.y , turretAngle , 1, 1, offset.x, offset.y)
    love.graphics.draw(gunsImg, position.x , position.y , turretAngle , 1, 1, offset.x, offset.y)
end

tank.init = function()
    tankAngle = 0
    rotationSpeed = 2
    direction = 0
    rotationDirection = 0
    position.x = SCREEN_SIZE.width * .5
    position.y =  SCREEN_SIZE.height * .5
    speed = 400

    turretAngle = 0
    firePoint.x = 0
    firePoint.y = 0
end

tank.getPosition = function()
    return position
end

tank.takeDamage = function(damage)
    health = health - damage
    if(health <= 0) then
        if tank.gameOverCallback then
            tank.gameOverCallback()
        end
    end
end

tank.getHealth = function()
    return health
end

return tank