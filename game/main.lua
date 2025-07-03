-- Block Smasher
-- Gabriel Antônio - 2025
---@diagnostic disable: undefined-global
---@diagnostic disable: duplicate-set-field

-- Defines the game object
Game = {
    name = "Block Smasher",
    author = "Gabriel Antônio",
    state = "menu",
    resetFont = function()
        love.graphics.setFont(love.graphics.newFont(12))
        love.graphics.setColor({255, 255, 255, 255})
    end
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

-- Variables declarations
local Width, Height
local MenuBackground, LogoImage, StartButton, ExitButton
local BallCollisionSound
local StartButtonX, StartButtonY, StartButtonWidth, StartButtonHeight = 0, 0, 0, 0
local ExitButtonX, ExitButtonY, ExitButtonWidth, ExitButtonHeight = 0, 0, 0, 0
local DefaultCursor, HandCursor

-- Defines the ball as an object
Ball = {
    x = 0,
    y = 0,
    radius = 15,
    xspeed = 300,
    yspeed = 300
}


-------------------------------------------------------------------
-- Load Section


-- Main Love Load Function
function love.load()
    -- Gets the width and height dimensions
    Width, Height = love.graphics.getDimensions()

    -- Loads logo image
    LogoImage = love.graphics.newImage("assets/logo.png")

    -- Loads collision sound
    BallCollisionSound = love.audio.newSource("assets/ball_collision.wav", "static")

    -- Loads menu assets
    MenuBackground = love.graphics.newImage("assets/fundo.png")
    StartButton = love.graphics.newImage("assets/start.png")
    ExitButton = love.graphics.newImage("assets/exit.png")

    -- Loads the default and hand cursors
    DefaultCursor = love.mouse.newCursor("assets/pointer.png", 0, 0)
    HandCursor = love.mouse.newCursor("assets/link.png", 0, 0)
    love.mouse.setCursor(DefaultCursor)

    -- Loads the game state
    if Game.state == "menu" then
        SetupMenuLayout()
    elseif Game.state == "game" then
        LoadGame()
    end
end

-- Function to setup menu layout
function SetupMenuLayout()
    -- Calculates scaled dimensions
    StartButtonScaledWidth = StartButton:getWidth() * 0.35
    StartButtonScaledHeight = StartButton:getHeight() * 0.35
    -- Calculates top-left corner for start button
    StartButtonX = Width / 2 - StartButtonScaledWidth / 2
    StartButtonY = Height * 0.65 - StartButtonScaledHeight / 2
    StartButtonWidth = StartButtonScaledWidth
    StartButtonHeight = StartButtonScaledHeight

    -- Loads the exit game button image
    ExitButtonScaledWidth = ExitButton:getWidth() * 0.35
    ExitButtonScaledHeight = ExitButton:getHeight() * 0.35
    -- Calculates top-left corner for exit button
    ExitButtonX = Width / 2 - ExitButtonScaledWidth / 2
    ExitButtonY = Height * 0.8 - ExitButtonScaledHeight / 2
    ExitButtonWidth = ExitButtonScaledWidth
    ExitButtonHeight = ExitButtonScaledHeight
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
    -- If the mouse is over the Start button
    if IsMouseOver(StartButtonX, StartButtonY, StartButtonWidth, StartButtonHeight) then
        love.mouse.setCursor(HandCursor)
    -- If the mouse is over the Exit button
    elseif IsMouseOver(ExitButtonX, ExitButtonY, ExitButtonWidth, ExitButtonHeight) then
        love.mouse.setCursor(HandCursor)
    -- If the mouse is not over any button
    else
        love.mouse.setCursor(DefaultCursor)
    end
end

-- Function to update the game itself
function UpdateGame(dt)
    -- Handles horizontal ball movement
    Ball.x = Ball.x + Ball.xspeed * dt

    -- Handles vertical ball movement
    Ball.y = Ball.y + Ball.yspeed * dt

    -- Right Edge Collision
    if Ball.x + Ball.radius > Width then
        -- Reverses the ball's X speed to move left
        Ball.xspeed = -Ball.xspeed
        -- Repositions to prevent the ball from sticking
        Ball.x = Width - Ball.radius - 1

        -- Plays the collision sound
        BallCollisionSound:play()
    end

    -- Left Edge Collision
    if Ball.x - Ball.radius < 0 then
        -- Reverses the ball's X speed to move right
        Ball.xspeed = -Ball.xspeed
        -- Repositions to prevent the ball from sticking
        Ball.x = Ball.radius + 1

        -- Plays the collision sound
        BallCollisionSound:play()
    end

    -- Top Edge Collision
    if Ball.y - Ball.radius < 0 then
        -- Reverses the ball's Y speed to move down
        Ball.yspeed = -Ball.yspeed
        -- Repositions to prevent the ball from sticking
        Ball.y = Ball.radius + 1

        -- Plays the collision sound
        BallCollisionSound:play()
    end

    -- Bottom Edge Collision
    if Ball.y + Ball.radius > Height then
        -- Reverses the ball's Y speed to move up
        Ball.yspeed = -Ball.yspeed
        -- Repositions to prevent the ball from sticking
        Ball.y = Height - Ball.radius - 1

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
        -- Draws the background image scaled to fit the window
        love.graphics.draw(MenuBackground, 0, 0, 0, Width / MenuBackground:getWidth(), Height / MenuBackground:getHeight())
    end

    -- Checks if there is a logo image loaded
    if LogoImage then
        -- Draws the logo image scaled to fit the window
        love.graphics.draw(LogoImage, Width / 2, Height * 0.35, 0, 0.65, 0.65, LogoImage:getWidth() / 2, LogoImage:getHeight() / 2)
    end

    -- Checks if there is a start button image loaded
    if StartButton then
        -- Draws the start button image scaled to fit the window, centered
        love.graphics.draw(StartButton, Width / 2, Height * 0.65, 0, 0.35, 0.35, StartButton:getWidth() / 2, StartButton:getHeight() / 2)
    end

    -- Checks if there is an exit button image loaded
    if ExitButton then
        -- Draws the exit button image scaled to fit the window, centered
        love.graphics.draw(ExitButton, Width / 2, Height * 0.8, 0, 0.35, 0.35, ExitButton:getWidth() / 2, ExitButton:getHeight() / 2)
    end
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


-------------------------------------------------------------------
-- Event Handlers


-- Function to check if the mouse is over a rectangle
function IsMouseOver(x, y, width, height)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    return mouseX >= x and mouseX <= x + width and
           mouseY >= y and mouseY <= y + height
end

-- Function to handle mouse click events
function love.mousepressed(x, y, button)
    -- If the game state is "menu"
    if Game.state == "menu" then
        -- If the left mouse button was pressed (button == 1)
        if button == 1 then
            -- If the click was over the Start button
            if IsMouseOver(StartButtonX, StartButtonY, StartButtonWidth, StartButtonHeight) then
                Game.state = "game"
                LoadGame()
            -- If the click was over the Exit button
            elseif IsMouseOver(ExitButtonX, ExitButtonY, ExitButtonWidth, ExitButtonHeight) then
                love.event.quit()
            end
        end
    end
end