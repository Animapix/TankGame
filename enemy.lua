
local droneImg = love.graphics.newImage("assets/images/Enemies/Drone/Drone.png")

local offset = { x = droneImg:getWidth() * .5 , y= droneImg:getHeight() * .5 }

function newEnemy(x, y, speed, target)
    local enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.speed = speed
    enemy.patrolSpeed = speed * 0.5
    enemy.target = target
    enemy.visionRange = 200
    enemy.attackRange = 50
    enemy.health = 100
    enemy.angle = math.random(0, 2 * math.pi)
    enemy.patrolTimer = math.random(1, 3)
    enemy.radius = 50
    enemy.damage = 10
    enemy.state = "patrol"
    enemy.isFree = false

    enemy.draw = function()
        love.graphics.draw(droneImg, enemy.x , enemy.y , enemy.angle , 1, 1, offset.x, offset.y)
    end

    enemy.update = function(dt)
        local targetPosition = enemy.target.getPosition()
        local dist = distance(enemy.x, enemy.y, targetPosition.x, targetPosition.y)

        if enemy.state == "patrol" then
            enemy.patrol(dt)
            
            if dist < enemy.visionRange then
                enemy.state = "chase"
            end
        elseif enemy.state == "chase" then
            enemy.chase(dt)

            if dist > enemy.visionRange * 1.5 then
                enemy.state = "patrol"
            end
        end

    end

    enemy.patrol = function(dt)
        enemy.patrolTimer = enemy.patrolTimer - dt
        if enemy.patrolTimer <= 0 then
            enemy.angle = math.random(0, 2 * math.pi)
            enemy.patrolTimer = math.random(1, 3)
        end
        enemy.move(dt, enemy.patrolSpeed)
    end

    enemy.chase = function(dt)
        if not enemy.target then return end
        local targetPosition = target.getPosition()
        local dx = targetPosition.x - enemy.x
        local dy = targetPosition.y - enemy.y
        enemy.angle = math.atan2(dy, dx)
        enemy.move(dt, enemy.speed)
    end

    enemy.attack = function()

    end
    
    enemy.setTarget = function(target)
        enemy.target = target
    end

    enemy.move = function(dt, speed)
        enemy.x = enemy.x + math.cos(enemy.angle) * speed * dt
        enemy.y = enemy.y + math.sin(enemy.angle) * speed * dt
    end

    enemy.takeDamage = function(damage)
        enemy.health = enemy.health - damage
        if enemy.health <= 0 then
            enemy.isFree = true
        end
    end

    return enemy
end