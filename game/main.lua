-- Gabriel Antônio 2025
---@diagnostic disable: undefined-global
---@diagnostic disable: duplicate-set-field

-- Defines the game state as 'menu'
GameState = "menu" 

-- Define the ball as an object
Ball = {
    x = 0,
    y = 0,
    radius = 15,
    speed = 300
}

-- Defining variables
local ballCollisionSound, menuBackground


-------------------------------------------------------------------
-- Load Section


-- Main Love Load Function
function love.load()
    -- Get width and height dimensions
    Width, Height = love.graphics.getDimensions()

    -- Load collision sound
    ballCollisionSound = love.audio.newSource("ball_collision.wav", "static")

    -- If game state is 'menu'
    if GameState == 'menu' then
        loadMenu()
    -- If game state is 'game'
    elseif GameState == 'game' then
        loadGame()
    end
end

-- Function to load menu assets
function loadMenu()
    return 0
end

-- Function to load main game assets
function loadGame()
    -- Define the initial ball position
    Ball.x = Ball.radius
    Ball.y = Height / 2
end


-------------------------------------------------------------------
-- Update Section


-- Main Love Update Function
function love.update(dt)
    -- If game state is 'menu'
    if GameState == 'menu' then
        updateMenu(dt)
    -- If game state is 'game'
    elseif GameState == 'game' then
        updateGame(dt)
    end
end

-- Function to update the game menu
function updateMenu(dt)
    return 0
end

-- Function to update the game itself
function updateGame(dt)
    -- Handles horizontal ball movement
    Ball.x = Ball.x + Ball.speed * dt

    -- Right Edge Collision
    if Ball.x + Ball.radius > Width then
        -- Invert ball speed to move left
        Ball.speed = -Ball.speed
        -- Reposition to prevent the ball from sticking
        Ball.x = Width - Ball.radius - 1

        -- Play the collision sound
        ballCollisionSound:play()
    end

    -- Left Edge Collision
    if Ball.x - Ball.radius < 0 then
        -- Invert ball speed to move right
        Ball.speed = -Ball.speed
        -- Reposition to prevent the ball from sticking
        Ball.x = Ball.radius + 1

        -- Play the collision sound
        ballCollisionSound:play()
    end
end


-------------------------------------------------------------------
-- Draw Section


-- Main Love Draw Function
function love.draw()
    -- If game state is 'menu'
    if GameState == 'menu' then
        drawMenu()
    -- If game state is 'game'
    elseif GameState == 'game' then
        drawGame()
    end
end

-- Function to draw the menu assets
function drawMenu()
    return 0
end

-- Function to draw the game assets
function drawGame()
    -- Draw the ball itself
    love.graphics.circle("line", Ball.x, Ball.y, Ball.radius)

    -- Displaying messages
    love.graphics.print('Block Smasher', 10, 10)
    love.graphics.print('Hello World!', 150, 10)

    -- Show statistics in real time
    love.graphics.print("Ball.X: " .. tostring(Ball.x), 10, 30)
    love.graphics.print("Ball.Y: " .. tostring(Ball.y), 160, 30)
end
