require("helpers")
require("enemy")

SCREEN_SIZE = { width =  1920, height = 1080 }

local tank = require("tank")

local currentScene = "Game"

local bullets = {}
local enemies = {}

local score = 0

function love.load()
    print(_VERSION)
    love.window.setMode(SCREEN_SIZE.width, SCREEN_SIZE.height)
    love.window.setTitle("Tank game")

    table.insert(enemies, newEnemy(200, 200, 100, tank))
    table.insert(enemies, newEnemy(1800, 200, 100, tank))
    table.insert(enemies, newEnemy(1800, 1000, 100, tank))
    table.insert(enemies, newEnemy(400, 900, 100, tank))

    tank.gameOverCallback = function()
        currentScene = "Menu"
    end

end

function love.update(dt)
    if currentScene == "Menu" then
        
    elseif currentScene == "Game" then
        updateGame(dt)
    end
end


function updateGame(dt)
    local dir,dirRot = GetInputs();
    tank.move(dir)
    tank.rotate(dirRot)
    tank.aim(love.mouse.getPosition())

    tank.update(dt)

    for _,bullet in ipairs(bullets) do
        bullet.update(dt)
    end

    for _,enemy in ipairs(enemies) do
        enemy.update(dt)
    end

    processCollisions()

    for index = #bullets, 1, -1 do 
        if bullets[index].isFree then
            table.remove(bullets, index)
        end
    end

    for index = #enemies, 1, -1 do 
        if enemies[index].isFree then
            table.remove(enemies, index)
            score = score + 1
            if #enemies == 0 then
                currentScene = "Menu"
            end
        end
    end
    
end

function processCollisions()

    for _,bullet in ipairs(bullets) do
        for _,enemy in ipairs(enemies) do
            
            if circleCollision(enemy.x, enemy.y, enemy.radius, bullet.pX, bullet.pY, bullet.radius) then
                bullet.isFree = true
                enemy.takeDamage(bullet.damage)
            end
        end
    end

    for _,enemy in ipairs(enemies) do
        if circleCollision(tank.getPosition().x, tank.getPosition().y, tank.radius, enemy.x, enemy.y, enemy.radius) then
            tank.takeDamage(enemy.damage)
        end
    end

end

function GetInputs()
    local dir = 0
    local rotDir = 0
    
    if love.keyboard.isDown("w") then
        dir = 1
    elseif love.keyboard.isDown("s") then
        dir = -1
    end

    if love.keyboard.isDown("a") then
        rotDir = 1
    elseif love.keyboard.isDown("d") then
        rotDir = -1
    end

    return dir, rotDir
end

function love.draw()
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)


    if currentScene == "Menu" then
        love.graphics.print("Menu", 10, 10)


    elseif currentScene == "Game" then
        
        tank.draw()


        for _,bullet in ipairs(bullets) do
            bullet.draw()
        end
        
        for _,enemy in ipairs(enemies) do
            enemy.draw()
        end

        love.graphics.print(#bullets, 10, 10)

        DrawDebug()
    end



end


function DrawDebug()
    love.graphics.setColor(0, 1, 0, 1)
    for _,bullet in ipairs(bullets) do
        love.graphics.circle("line", bullet.pX, bullet.pY , bullet.radius)
    end

    for _,enemy in ipairs(enemies) do
        love.graphics.circle("line", enemy.x, enemy.y , enemy.radius)
    end

    local tankPos = tank.getPosition()
    love.graphics.circle("line", tankPos.x, tankPos.y , tank.radius)


    love.graphics.setColor(1, 1, 1, 1)
end


function love.mousepressed(x, y, button)
    if button == 1 then
        local b = tank.fire()
        table.insert(bullets, b)
    end
end

function love.keypressed(key)
    if key == "g" and currentScene == "Menu" then
        initGame()
    elseif key == "m" and currentScene == "Game" then
        currentScene = "Menu"
    end
end


function initGame()
    currentScene = "Game"
    tank.init()
    bullets = {}
end