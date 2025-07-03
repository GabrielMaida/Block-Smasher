-- Block Smasher
-- Gabriel Antônio - 2025
---@diagnostic disable: undefined-global
---@diagnostic disable: duplicate-set-field

-- Defines the Game object
Game = {
    name = "Block Smasher",
    author = "Gabriel Antônio",
    state = "menu",
    winorlose = nil,
    resetFont = function()
        love.graphics.setFont(love.graphics.newFont(12))
        love.graphics.setColor({255, 255, 255, 255})
    end,
    start = function()
        Game.winorlose = nil
        GameOverMusic:stop()
        VictoryMusic:stop()
        VictoryVoice:stop()
        GameStartSound:setVolume(0.4)
        GameStartSound:play()
        Game.state = "game"
        LoadGame()
    end,
    exit = function()
        love.event.quit()
    end,
    gameover = function()
        Game.winorlose = 0
        BackgroundMusic:stop()
        GameOverSound:setVolume(0.3)
        GameOverSound:play()
        GameOverMusic:setVolume(0.15)
        GameOverMusic:play()
        SetupPostGameMenuLayout()
    end,
    victory = function()
        Game.winorlose = 1
        BackgroundMusic:stop()
        GameOverMusic:stop()
        VictoryVoice:setVolume(0.3)
        VictoryVoice:play()
        VictoryMusic:setVolume(0.2)
        VictoryMusic:play()
        SetupPostGameMenuLayout()
    end,
    menu = function()
        Game.winorlose = nil
        GameOverMusic:stop()
        VictoryMusic:stop()
        VictoryVoice:stop()
        BackgroundMusic:setVolume(0.15)
        BackgroundMusic:play()
        Game.state = "menu"
        SetupMenuLayout()
    end
}

-- Loads background music
BackgroundMusic = love.audio.newSource("assets/game_music.mp3", "static")

-- Loads game start sound
GameStartSound = love.audio.newSource("assets/game_start.mp3", "static")

-- Loads game over sound
GameOverSound = love.audio.newSource("assets/game_over_sound.mp3", "static")

-- Loads game over music
GameOverMusic = love.audio.newSource("assets/game_over_music.mp3", "static")

-- Arguments validation
if arg[2] ~= nil then
    -- Prints an command line error message
    io.stderr:write("Error: Invalid argument provided: '" .. arg[2] .. "'.\nUse 'love .' for starting the game.\n")
    os.exit(1)
end

-- Variables declarations
local MenuBackground, LogoImage, StartButton, ExitButton, BallAsset, BrickAsset
local BallCollisionSound
local StartButtonX, StartButtonY, StartButtonWidth, StartButtonHeight = 0, 0, 0, 0
local ExitButtonX, ExitButtonY, ExitButtonWidth, ExitButtonHeight = 0, 0, 0, 0
local DefaultCursor, HandCursor
local PlayAgainButton, MenuButton

-- Variables for the floating animation of the CloudAsset in the menu
local Cloud1X, Cloud2X -- The X positions
local Cloud1Speed = 30 -- The speed of the first cloud
local Cloud2Speed = 80 -- The speed of the second cloud

-- Variables for the floating animation of Menu assets
local MenuFloatOffset = 0 -- The vertical offset
local MenuFloatSpeed = 2 -- Controls the floating speed
local MenuFloatAmplitude = 5 -- Controls the maximum floating height in pixels

-- Variables for timer
local GameStartTimer = 0
local IsGameStarting = false

-- Variables for the game ball and bricks
local BallGameAsset
local BrickGameAsset

-- Defines the bricks table
local Bricks = {}

-- Defines the bricks properties (constants)
local BRICK_WIDTH -- Width of each brick
local BRICK_HEIGHT -- Height of each brick
local BRICK_PADDING -- Space between bricks
local BRICK_OFFSET_TOP -- Distance from the top of the screen
local BRICK_OFFSET_LEFT -- Distance from the left of the screen

-- Defines the ball object
Ball = {
    x = 0,
    y = 0,
    radius = 0,
    xspeed = 0,
    yspeed = 0
}

-- Defines the paddle object
Paddle = {
    x = 0,
    y = 0,
    width = 100,
    height = 20,
    speed = 500
}


-------------------------------------------------------------------
-- Load Section


-- Main Love Load Function
function love.load()
    -- Gets the width and height dimensions
    Width, Height = love.graphics.getDimensions()

    -- Defines the bricks properties (constants)
    BRICK_WIDTH = Width / 9
    BRICK_HEIGHT = 60
    BRICK_PADDING = BRICK_WIDTH / 5
    BRICK_OFFSET_TOP = Height / 10
    BRICK_OFFSET_LEFT = Width / 9

    -- Loads menu assets
    LogoImage = love.graphics.newImage("assets/logo.png")
    MenuBackground = love.graphics.newImage("assets/menu_background.png")
    StartButton = love.graphics.newImage("assets/start.png")
    ExitButton = love.graphics.newImage("assets/exit.png")
    BallAsset = love.graphics.newImage("assets/ball.png")
    BrickAsset = love.graphics.newImage("assets/brick.png")
    CloudAsset1 = love.graphics.newImage("assets/cloud1.png")
    CloudAsset2 = love.graphics.newImage("assets/cloud2.png")
    
    -- Initializes cloud positions
    Cloud1X = Width * 0.8  -- Same initial X position as DrawMenu
    Cloud2X = Width * 0.18 -- Same initial X position as DrawMenu

    -- Loads the default and pointer cursors
    DefaultCursor = love.mouse.newCursor("assets/pointer.png", 0, 0)
    HandCursor = love.mouse.newCursor("assets/cursor.png", 0, 0)
    love.mouse.setCursor(DefaultCursor)

    -- Loads the game ball and bricks
    BallGameAsset = love.graphics.newImage("assets/game_ball.png")
    BrickGameAsset = love.graphics.newImage("assets/game_brick.png")

    -- Defines the scale for the ball image
    local desiredBallGameScale = 0.1

    -- Calculates the new radius of the ball based on the scaled image size
    -- We consider the ball's diameter to be the smaller between width/height or a specific value
    -- If your ball image (without fire) is square, BallGameAsset:getWidth() is sufficient.
    -- If there's fire, the 'body' of the ball might be slightly smaller than the total image width/height.
    local visualBallDiameter = BallGameAsset:getWidth() * desiredBallGameScale -- or BallGameAsset:getHeight() * desiredBallGameScale
    Ball.radius = visualBallDiameter / 2

    -- Loads main game assets
    BallCollisionSound = love.audio.newSource("assets/ball_collision.wav", "static")
    VictoryMusic = love.audio.newSource("assets/victory_music.mp3", "static")
    VictoryVoice = love.audio.newSource("assets/victory_voice.mp3", "static")
    MenuButton = love.graphics.newImage("assets/back_menu.png")

    -- Loads the game state
    if Game.state == "menu" then
        Game.menu()
    elseif Game.state == "game" then
        Game.start()
    end
end

-- Function to setup menu layout
function SetupMenuLayout()
    -- Calculates scaled dimensions
    StartButtonScaledWidth = StartButton:getWidth() * 0.35
    StartButtonScaledHeight = StartButton:getHeight() * 0.35
    -- Calculates the center Y position for the Start button
    local actualStartButtonCenterY = Height * 0.6
    -- Calculates the X and Y positions for the Start button
    StartButtonX = Width / 2 - StartButtonScaledWidth / 2
    StartButtonY = actualStartButtonCenterY - StartButtonScaledHeight / 2
    -- Sets the width and height for the Start button
    StartButtonWidth = StartButtonScaledWidth
    StartButtonHeight = StartButtonScaledHeight

    -- Loads the exit game button image
    ExitButtonScaledWidth = ExitButton:getWidth() * 0.35
    ExitButtonScaledHeight = ExitButton:getHeight() * 0.35
    -- Calculates the center Y position for the Exit button
    local actualExitButtonCenterY = Height * 0.75
    -- Calculates the X and Y positions for the Exit button
    ExitButtonX = Width / 2 - ExitButtonScaledWidth / 2
    ExitButtonY = actualExitButtonCenterY - ExitButtonScaledHeight / 2
    -- Sets the width and height for the Exit button
    ExitButtonWidth = ExitButtonScaledWidth
    ExitButtonHeight = ExitButtonScaledHeight
end

-- Function to load main game assets
function LoadGame()
    -- Loads the game background
    GameBackground = love.graphics.newImage("assets/game_background.png")

    -- Defines the initial ball position
    Ball.x = Width / 2
    Ball.y = Height - Paddle.height - 30 - Ball.radius - 10
    Ball.xspeed = 0
    Ball.yspeed = 0

    -- Defines the initial paddle position
    Paddle.x = Width / 2 - Paddle.width / 2
    Paddle.y = Height - Paddle.height - 30

    -- Sets the game start timer and flag
    GameStartTimer = 3
    IsGameStarting = true

    -- Initializes bricks
    Bricks = {}
    local columns = 6
    local rows = 4

    for row = 0, rows - 1 do
        for col = 0, columns - 1 do
            local brick = {}
            brick.width = BRICK_WIDTH
            brick.height = BRICK_HEIGHT
            brick.x = BRICK_OFFSET_LEFT + (col * (BRICK_WIDTH + BRICK_PADDING))
            brick.y = BRICK_OFFSET_TOP + (row * (BRICK_HEIGHT + BRICK_PADDING))
            brick.isAlive = true
            table.insert(Bricks, brick)
        end
    end
end

function SetupPostGameMenuLayout()
    -- Button scale
    local buttonScale = 0.35
    local menuButtonSpecificScale = 0.13

    -- Play Again Button
    PlayAgainButton = StartButton
    PlayAgainButtonWidth = PlayAgainButton:getWidth() * buttonScale
    PlayAgainButtonHeight = PlayAgainButton:getHeight() * buttonScale
    PlayAgainButtonX = Width / 2 - PlayAgainButtonWidth / 2
    PlayAgainButtonY = Height * 0.5 - PlayAgainButtonHeight / 2

    -- Back to Menu Button
    MenuButtonWidth = MenuButton:getWidth() * menuButtonSpecificScale
    MenuButtonHeight = MenuButton:getHeight() * menuButtonSpecificScale
    MenuButtonX = Width / 2 - MenuButtonWidth / 2
    MenuButtonY = Height * 0.65 - MenuButtonHeight / 2

    -- Exit Game Button
    ExitButtonWidth = ExitButton:getWidth() * buttonScale
    ExitButtonHeight = ExitButton:getHeight() * buttonScale
    ExitButtonX = Width / 2 - ExitButtonWidth / 2
    ExitButtonY = Height * 0.8 - ExitButtonHeight / 2
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
        -- Se o jogo NÃO estiver em status de vitória/derrota (Game.winorlose == nil), atualiza o jogo.
        if Game.winorlose == nil then
            UpdateGame(dt)
        else
            -- Se o jogo está em status de vitória/derrota, apenas atualiza o cursor para os botões pós-jogo
            if IsMouseOver(PlayAgainButtonX, PlayAgainButtonY, PlayAgainButtonWidth, PlayAgainButtonHeight) or
               IsMouseOver(MenuButtonX, MenuButtonY, MenuButtonWidth, MenuButtonHeight) or
               IsMouseOver(ExitButtonX, ExitButtonY, ExitButtonWidth, ExitButtonHeight) then
                love.mouse.setCursor(HandCursor)
            else
                love.mouse.setCursor(DefaultCursor)
            end
        end
    end
end
-- Function to update the game menu
function UpdateMenu(dt)
    -- Cloud movement (CloudAsset1)
    Cloud1X = Cloud1X - Cloud1Speed * dt -- Moves to the left
    if Cloud1X + CloudAsset1:getWidth() * 0.55 / 2 < 0 then
        -- If the cloud has completely moved to the left, repositions on the right
        Cloud1X = Width + CloudAsset1:getWidth() * 0.55 / 2
    end

    -- Cloud movement (CloudAsset2)
    Cloud2X = Cloud2X + Cloud2Speed * dt -- Moves to the right
    if Cloud2X - CloudAsset2:getWidth() * 0.55 / 2 > Width then
        -- If the cloud has completely moved to the right, repositions on the left
        Cloud2X = -CloudAsset2:getWidth() * 0.55 / 2
    end

    -- Updates the floating offset of the Menu assets in the menu
    -- math.sin(x) creates a wave that goes from -1 to 1. Multiplying by amplitude gives the desired range.
    MenuFloatOffset = math.sin(love.timer.getTime() * MenuFloatSpeed) * MenuFloatAmplitude

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
    -- Provisory key to test victory
    if love.keyboard.isDown('w') then
        Game.victory()
    end

    -- Handles paddle movement (always active)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        Paddle.x = Paddle.x - Paddle.speed * dt
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        Paddle.x = Paddle.x + Paddle.speed * dt
    end

    -- Paddle boundary checks
    -- Prevent paddle from going off screen left
    if Paddle.x < 0 then
        Paddle.x = 0
    end
    -- Prevent paddle from going off screen right
    if Paddle.x + Paddle.width > Width then
        Paddle.x = Width - Paddle.width
    end

    -- Game start timer logic
    if IsGameStarting then
        GameStartTimer = GameStartTimer - dt -- Decrement the timer
        if GameStartTimer <= 0 then
            IsGameStarting = false -- Countdown finished
            GameStartTimer = 0 -- Ensures it doesn't go negative
            -- Start ball movement
            Ball.xspeed = 300 -- Initial X speed
            Ball.yspeed = -300 -- Initial Y speed (upwards)
        end
    else
        -- Only move the ball and process collisions if the countdown is NOT active
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
        -- If the ball passes the paddle, it's a "game over" condition
        if Ball.y + Ball.radius > Height then
            
            -- Stops the ball (this might be handled better in Game.gameover() itself, but fine for now)
            Ball.xspeed = 0
            Ball.yspeed = 0
            -- Note: Setting Ball.x and Ball.y here might cause a visual jump if Game.gameover() also resets it
            Ball.x = Width / 2
            Ball.y = Height / 2

            Game.gameover()
        end

        -- Ball-Paddle Collision
        -- Check for overlap between ball and paddle
        if Ball.x + Ball.radius >= Paddle.x and
           Ball.x - Ball.radius <= Paddle.x + Paddle.width and
           Ball.y + Ball.radius >= Paddle.y and
           Ball.y - Ball.radius <= Paddle.y + Paddle.height then

            -- Determine the previous position of the ball
            -- This determine which side the collision occurred from
            local prevBallX = Ball.x - (Ball.xspeed * dt)
            local prevBallY = Ball.y - (Ball.yspeed * dt)

            -- Collision from Top of Paddle
            -- If the ball was above the paddle in the previous frame and is now overlapping
            if prevBallY + Ball.radius <= Paddle.y then
                Ball.yspeed = -Ball.yspeed -- Inverts the Y speed
                Ball.y = Paddle.y - Ball.radius -- Positions the ball at the top of the paddle

                -- Logic to vary the bounce angle at the top
                local hitPoint = (Ball.x - Paddle.x) / Paddle.width
                local maxBounceAngleFactor = 0.8
                Ball.xspeed = Ball.xspeed + (hitPoint - 0.5) * Paddle.speed * maxBounceAngleFactor

                -- Keep the total speed (magnitude) constant
                local currentSpeedMagnitude = math.sqrt(Ball.xspeed^2 + Ball.yspeed^2)
                local desiredSpeedMagnitude = 450 -- Use 450 como definido para o jogo
                if currentSpeedMagnitude ~= 0 then
                    local scaleFactor = desiredSpeedMagnitude / currentSpeedMagnitude
                    Ball.xspeed = Ball.xspeed * scaleFactor
                    Ball.yspeed = Ball.yspeed * scaleFactor
                end

                BallCollisionSound:play()
            end

            -- Collision from Left Side of Paddle
            -- If the ball was to the left of the paddle previously and now overlaps AND is moving right
            if prevBallX + Ball.radius <= Paddle.x and Ball.xspeed > 0 then
                Ball.xspeed = -Ball.xspeed -- Inverts the X speed
                Ball.x = Paddle.x - Ball.radius -- Positions the ball at the left of the paddle
                BallCollisionSound:play()
            end

            -- Collision from Right Side of Paddle
            -- If the ball was to the right of the paddle previously and now overlaps AND is moving left
            if prevBallX - Ball.radius >= Paddle.x + Paddle.width and Ball.xspeed < 0 then
                Ball.xspeed = -Ball.xspeed -- Inverts the X speed
                Ball.x = (Paddle.x + Paddle.width) + Ball.radius -- Positions the ball at the right of the paddle
                BallCollisionSound:play()
            end
        end

        -- Ball-Brick Collision
        -- Iterates through all bricks to check for collision
        for i, brick in ipairs(Bricks) do
            if brick.isAlive then -- Only check collision with alive bricks
                -- Check for overlap between ball and brick (AABB collision)
                if Ball.x + Ball.radius >= brick.x and
                   Ball.x - Ball.radius <= brick.x + brick.width and
                   Ball.y + Ball.radius >= brick.y and
                   Ball.y - Ball.radius <= brick.y + brick.height then

                    -- Determine the previous position of the ball
                    local prevBallX = Ball.x - (Ball.xspeed * dt)
                    local prevBallY = Ball.y - (Ball.yspeed * dt)

                    -- Destroy the brick
                    brick.isAlive = false
                    BallCollisionSound:play() -- Play sound when brick is hit

                    -- Determine which side the collision occurred from to invert the correct axis
                    local collided = false

                    -- Collision from Top of Brick
                    if prevBallY + Ball.radius <= brick.y then
                        Ball.yspeed = -Ball.yspeed
                        Ball.y = brick.y - Ball.radius -- Reposition to prevent sticking
                        collided = true
                    end

                    -- Collision from Bottom of Brick
                    if not collided and prevBallY - Ball.radius >= brick.y + brick.height then
                        Ball.yspeed = -Ball.yspeed
                        Ball.y = (brick.y + brick.height) + Ball.radius
                        collided = true
                    end

                    -- Collision from Left Side of Brick
                    if not collided and prevBallX + Ball.radius <= brick.x then
                        Ball.xspeed = -Ball.xspeed
                        Ball.x = brick.x - Ball.radius
                        collided = true
                    end

                    -- Collision from Right Side of Brick
                    if not collided and prevBallX - Ball.radius >= brick.x + brick.width then
                        Ball.xspeed = -Ball.xspeed
                        Ball.x = (brick.x + brick.width) + Ball.radius
                        collided = true
                    end

                    -- If the ball somehow hit a corner and didn't trigger an axis specific collision,
                    -- it inverts Y if no other side was hit.
                    if not collided then
                        Ball.yspeed = -Ball.yspeed
                    end

                    -- Adjusts the ball speed to maintain a constant magnitude
                    local currentSpeedMagnitude = math.sqrt(Ball.xspeed^2 + Ball.yspeed^2)
                    local desiredSpeedMagnitude = 450
                    if currentSpeedMagnitude ~= 0 then
                        local scaleFactor = desiredSpeedMagnitude / currentSpeedMagnitude
                        Ball.xspeed = Ball.xspeed * scaleFactor
                        Ball.yspeed = Ball.yspeed * scaleFactor
                    end

                    -- Only collide with one brick per frame to prevent weird multi-hit behavior
                    break
                end
            end
        end
    end

    local aliveBricksCount = 0
    for i, brick in ipairs(Bricks) do
        if brick.isAlive then
            aliveBricksCount = aliveBricksCount + 1
        end
    end

    if aliveBricksCount == 0 then
        Game.victory()
        return
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
        -- Calculates the scale for the background image
        local menuBackgroundScaleX = Width / MenuBackground:getWidth()
        local menuBackgroundScaleY = Height / MenuBackground:getHeight()
        
        -- Draws the background image scaled to fit the window
        love.graphics.draw(MenuBackground, 0, 0, 0, menuBackgroundScaleX, menuBackgroundScaleY)
    end

    -- Checks if there is a cloud image loaded
    if CloudAsset1 then
        -- Defines the position for the cloud image
        local cloudMenuY = Height * 0.1
        
        -- Defines the scale for the cloud image
        local cloudMenuScale = 0.55
        
        -- Draws the cloud
        love.graphics.draw(CloudAsset1, Cloud1X, cloudMenuY, 0, cloudMenuScale, cloudMenuScale, CloudAsset1:getWidth() / 2, CloudAsset1:getHeight() / 2)
    end

    -- Checks if there is a logo image loaded
    if LogoImage then
        -- Defines the position for the logo image
        local logoMenuX = Width / 2
        local logoMenuY = Height * 0.25
        
        -- Defines the scale for the logo image
        local logoMenuScale = 0.55

        -- Draws the logo image
        love.graphics.draw(LogoImage, logoMenuX, logoMenuY, 0, logoMenuScale, logoMenuScale, LogoImage:getWidth() / 2, LogoImage:getHeight() / 2)
    end

    -- Checks if there is a brick image loaded
    if BrickAsset then
        -- Defines the position for the brick image
        local brickMenuX = Width * 0.2
        local brickMenuY = Height * 0.68
        
        -- Defines the scale for the brick image
        local brickMenuScale = 0.55
        
        -- Draws the brick
        love.graphics.draw(BrickAsset, brickMenuX, brickMenuY - MenuFloatOffset, 0, brickMenuScale, brickMenuScale, BrickAsset:getWidth() / 2, BrickAsset:getHeight() / 2)
    end

    -- Checks if there is a cloud image loaded
    if CloudAsset2 then
        -- Defines the position for the cloud image
        local cloudMenuY = Height * 0.21
        
        -- Defines the scale for the cloud image
        local cloudMenuScale = 0.55
        
        -- Draws the cloud
        love.graphics.draw(CloudAsset2, Cloud2X, cloudMenuY, 0, cloudMenuScale, cloudMenuScale, CloudAsset2:getWidth() / 2, CloudAsset2:getHeight() / 2)
    end

    -- Checks if there is a ball image loaded
    if BallAsset then
        -- Defines the initial position for the ball image (without the offset)
        local ballMenuX = Width * 0.75
        local ballMenuY = Height * 0.5
        
        -- Defines the scale for the ball image
        local ballMenuScale = 0.45
        
        -- Draws the ball, adding the floating offset
        love.graphics.draw(BallAsset, ballMenuX, ballMenuY + MenuFloatOffset, 0, ballMenuScale, ballMenuScale, BallAsset:getWidth() / 2, BallAsset:getHeight() / 2)
    end

    -- Checks if there is a start button image loaded
    if StartButton then
        -- Defines the position for the start button image
        local startButtonX = Width / 2
        local startButtonY = Height * 0.6
        
        -- Defines the scale for the start button image
        local startButtonScale = 0.35
        
        -- Draws the start button image scaled to fit the window, centered
        love.graphics.draw(StartButton, startButtonX, startButtonY, 0, startButtonScale, startButtonScale, StartButton:getWidth() / 2, StartButton:getHeight() / 2)
    end

    -- Checks if there is an exit button image loaded
    if ExitButton then
        -- Defines the position for the exit button image
        local exitButtonX = Width / 2
        local exitButtonY = Height * 0.75

        -- Defines the scale for the exit button image
        local exitButtonScale = 0.35

        -- Draws the exit button image scaled to fit the window, centered
        love.graphics.draw(ExitButton, exitButtonX, exitButtonY, 0, exitButtonScale, exitButtonScale, ExitButton:getWidth() / 2, ExitButton:getHeight() / 2)
    end

    -- Credits on bottom right
    love.graphics.print("Developed by: Gabriel Maida", Width * 0.8, Height * 0.97)
    love.graphics.print("v1.0", Width * 0.958, Height * 0.94)
end

-- Function to draw the game assets
function DrawGame()
    -- Checks if there is a background image loaded
    if GameBackground then
        -- Calculates the scale for the background image
        local gameBackgroundScaleX = Width / GameBackground:getWidth()
        local gameBackgroundScaleY = Height / GameBackground:getHeight()

        -- Draws the background image scaled to fit the window
        love.graphics.draw(GameBackground, 0, 0, 0, gameBackgroundScaleX, gameBackgroundScaleY)
    end

    -- Draws bricks
    for i, brick in ipairs(Bricks) do
        if brick.isAlive then
            love.graphics.draw(BrickGameAsset, brick.x, brick.y, 0, brick.width / BrickGameAsset:getWidth(), brick.height / BrickGameAsset:getHeight())
            -- The scale is calculated here to adjust the image to the size defined of the brick.
            -- If your BrickGameAsset already has the correct dimensions, use a fixed scale (ex: 1)
            -- Or if you want to center it, add the offsets: BrickGameAsset:getWidth() / 2, BrickGameAsset:getHeight() / 2
        end
    end

    -- Checks if there is a paddle image loaded
    if Paddle then
        -- Draw the paddle
        love.graphics.rectangle("fill", Paddle.x, Paddle.y, Paddle.width, Paddle.height)
    end

    -- Checks if there is a ball image loaded
    if BallGameAsset then
        -- Calculates the angle of movement of the ball using atan2
        -- Adds pi/2 (90 degrees) to make the image point in the direction of movement (adjust according to your image)
---@diagnostic disable-next-line: deprecated
        local angle = math.atan2(Ball.yspeed, Ball.xspeed) + math.pi / 2

        -- Calculates the scale for the ball image
        local ballGameScale = 0.08

        -- Draws the ball image scaled to fit the window, centered
        love.graphics.draw(BallGameAsset, Ball.x, Ball.y, angle + 90, ballGameScale, ballGameScale, BallGameAsset:getWidth() / 2, BallGameAsset:getHeight() / 2)
    end

    -- Displaying messages
    love.graphics.print(Game.name, 10, 10)

    -- Show statistics in real time
    love.graphics.print("Ball.X: " .. tostring(string.format("%.5f", Ball.x)), 10, 30)
    love.graphics.print("Ball.Y: " .. tostring(string.format("%.5f", Ball.y)), 140, 30)
    love.graphics.print("Paddle.X: " .. tostring(string.format("%.5f", Paddle.x)), 270, 30)
    love.graphics.print("Paddle.Y: " .. tostring(string.format("%.5f", Paddle.y)), 420, 30)

    -- Draws the game start timer
    if IsGameStarting then
        love.graphics.setFont(love.graphics.newFont(100))
        love.graphics.setColor(0, 0, 0, 1)
        local timerText = tostring(math.ceil(GameStartTimer))
        local textWidth = love.graphics.getFont():getWidth(timerText)
        love.graphics.print(timerText, (Width - textWidth) / 2, Height / 2 + 75)
        Game.resetFont()
    end

    -- AQUI: A lógica para Game Over / Victory deve vir DEPOIS de desenhar o jogo normal
    -- e ser condicionada por Game.winorlose
    if Game.winorlose ~= nil then -- Se Game.winorlose não é nil (ou seja, é 0 ou 1)
        -- Desenha um overlay semitransparente para escurecer a tela
        love.graphics.setColor(0, 0, 0, 0.7) -- Preto com 70% de opacidade
        love.graphics.rectangle("fill", 0, 0, Width, Height)

        -- Voltar a cor para branco ANTES de desenhar os textos e botões
        love.graphics.setColor(1, 1, 1, 1)

        -- Desenha o texto "Victory" ou "Game Over!"
        love.graphics.setFont(love.graphics.newFont(70))
        local textToDisplay = ""
        if Game.winorlose == 1 then
            textToDisplay = "Victory!"
        else -- Game.winorlose == 0
            textToDisplay = "Game Over!"
        end
        local textWidth = love.graphics.getFont():getWidth(textToDisplay)
        love.graphics.print(textToDisplay, (Width - textWidth) / 2, Height * 0.25)
        Game.resetFont()

        -- Desenha os botões Play Again, Back to Menu, Exit Game
        -- Play Again
        love.graphics.draw(PlayAgainButton, PlayAgainButtonX, PlayAgainButtonY, 0, PlayAgainButtonWidth / PlayAgainButton:getWidth(), PlayAgainButtonHeight / PlayAgainButton:getHeight())
        -- Back to Menu
        love.graphics.draw(MenuButton, MenuButtonX, MenuButtonY, 0, MenuButtonWidth / MenuButton:getWidth(), MenuButtonHeight / MenuButton:getHeight())
        -- Exit Game
        love.graphics.draw(ExitButton, ExitButtonX, ExitButtonY, 0, ExitButtonWidth / ExitButton:getWidth(), ExitButtonHeight / ExitButton:getHeight())
    end
end


-------------------------------------------------------------------
-- Event Handlers


-- Function to check if the mouse is over a rectangle
function IsMouseOver(x, y, width, height)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    -- Returns true if the mouse is over
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
                Game.start()
            -- If the click was over the Exit button
            elseif IsMouseOver(ExitButtonX, ExitButtonY, ExitButtonWidth, ExitButtonHeight) then
                Game.exit()
            end
        end
    -- If the game state is "game" AND the game has ended (win or lose)
    elseif Game.state == "game" and Game.winorlose ~= nil then -- Condição ajustada aqui
        -- If the left mouse button was pressed (button == 1)
        if button == 1 then
            -- Play Again button
            if IsMouseOver(PlayAgainButtonX, PlayAgainButtonY, PlayAgainButtonWidth, PlayAgainButtonHeight) then
                Game.start()
            -- Back to Menu button
            elseif IsMouseOver(MenuButtonX, MenuButtonY, MenuButtonWidth, MenuButtonHeight) then
                Game.menu()
            -- Exit Game button
            elseif IsMouseOver(ExitButtonX, ExitButtonY, ExitButtonWidth, ExitButtonHeight) then
                Game.exit()
            end
        end
    end
end