-- Block Smasher
-- Gabriel Antônio - 2025
---@diagnostic disable: undefined-global
---@diagnostic disable: duplicate-set-field

-- Defines the game object
Game = {
    name = "Block Smasher",
    author = "Gabriel Antônio",
    state = "menu"
}

-- Arguments validation
if arg[2] == "game" then
    Game.state = "game"
elseif arg[2] ~= nil then
    -- Prints an command line error message
    io.stderr:write("Error: Invalid argument provided: '" .. arg[2] .. "'.\nUse 'love .' for starting the game or 'love . game' to skip the start menu.\n")
    -- Exits the game with an error code
    os.exit(1)
end

-- Defines the ball as an object
Ball = {
    x = 0,
    y = 0,
    radius = 15,
    speed = 300
}


-------------------------------------------------------------------
-- Load Section


-- Main Love Load Function
function love.load()
    -- Gets the width and height dimensions
    Width, Height = love.graphics.getDimensions()

    -- Loads collision sound
    BallCollisionSound = love.audio.newSource("ball_collision.wav", "static")

    -- If game state is "menu"
    if Game.state == "menu" then
        LoadMenu()
    -- If game state is "game"
    elseif Game.state == "game" then
        LoadGame()
    end
end

-- Function to load menu assets
function LoadMenu()
    -- Loads the background image for the menu
    MenuBackground = love.graphics.newImage("wallp2.jpeg")

    -- Defines the title object
    Title = {
        text = Game.name,
        font = love.graphics.newFont(80),
        color = {0, 0, 0, 255}
    }
    Title.width = Title.font:getWidth(Title.text)
end

-- Function to load main game assets
function LoadGame()
    -- Defines the initial ball position
    Ball.x = Ball.radius
    Ball.y = Height / 2
end


-------------------------------------------------------------------
-- Update Section


-- Main Love Update Function
function love.update(dt)
    -- If game state is "menu"
    if Game.state == "menu" then
        UpdateMenu(dt)
    -- If game state is "game"
    elseif Game.state == "game" then
        UpdateGame(dt)
    end
end

-- Function to update the game menu
function UpdateMenu(dt)
    return 0
end

-- Function to update the game itself
function UpdateGame(dt)
    -- Handles horizontal ball movement
    Ball.x = Ball.x + Ball.speed * dt

    -- Right Edge Collision
    if Ball.x + Ball.radius > Width then
        -- Reverses the ball speed to move left
        Ball.speed = -Ball.speed
        -- Repositions to prevent the ball from sticking
        Ball.x = Width - Ball.radius - 1

        -- Plays the collision sound
        BallCollisionSound:play()
    end

    -- Left Edge Collision
    if Ball.x - Ball.radius < 0 then
        -- Reverses the ball speed to move right
        Ball.speed = -Ball.speed
        -- Repositions to prevent the ball from sticking
        Ball.x = Ball.radius + 1

        -- Plays the collision sound
        BallCollisionSound:play()
    end
end

-------------------------------------------------------------------
-- Draw Section

-- Main Love Draw Function
function love.draw()
    -- If game state is "menu"
    if Game.state == "menu" then
        DrawMenu()
    -- If game state is "game"
    elseif Game.state == "game" then
        DrawGame()
    end
end

-- Function to draw the menu assets
function DrawMenu()
    -- Checks if there is a background image loaded
    if MenuBackground then
        -- Defines the image X and Y axis scales
        local scaleX = Width / MenuBackground:getWidth()
        local scaleY = Height / MenuBackground:getHeight()
        -- Draws the background image scaled to fit the window
        love.graphics.draw(MenuBackground, 0, 0, 0, scaleX, scaleY)
    end

    -- Sets the size of the title font
    love.graphics.setFont(Title.font)
    -- Sets the color of the title font
    love.graphics.setColor(Title.color)

    -- Displays the game title horizontally centered
    love.graphics.print(Title.text, Width / 2 - Title.width / 2, 200)

    -- Resets the color to white
    love.graphics.setColor(255, 255, 255, 255)
    -- Resets the font to the default
    love.graphics.setFont(love.graphics.newFont(12))
end

-- Function to draw the game assets
function DrawGame()
    -- Draw the ball itself
    love.graphics.circle("line", Ball.x, Ball.y, Ball.radius)

    -- Displaying messages
    love.graphics.print(Game.name, 10, 10)
    love.graphics.print("Hello World!", 150, 10)

    -- Show statistics in real time
    love.graphics.print("Ball.X: " .. tostring(Ball.x), 10, 30)
    love.graphics.print("Ball.Y: " .. tostring(Ball.y), 160, 30)
end
