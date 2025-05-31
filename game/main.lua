-- Gabriel Antônio 2025
---@diagnostic disable: undefined-global
---@diagnostic disable: duplicate-set-field

-- Define the object of the Ball
Ball = {
    x = 0,
    y = 0,
    radius = 15,
    speed = 300
}

function love.load()
    -- Get Width and Height dimensions
    Width, Height = love.graphics.getDimensions()
    Ball.x = Ball.radius
    Ball.y = Height / 2
end

function love.update(dt)
    Ball.x = Ball.x + Ball.speed * dt

    -- Limite direito
    if Ball.x + Ball.radius > Width then
        Ball.x = Width
    end

    -- Limite esquerdo
    if Ball.x <= Ball.radius then
        Ball.x = Ball.radius + 1
        Ball.speed = -Ball.speed
    end
end

function love.draw()
    -- Draw the ball
    love.graphics.circle("line", Ball.x, Ball.y, Ball.radius)

    love.graphics.print('Hello World!', 10, 10)

    -- Show Real Time Statistics
    love.graphics.print("Ball.X: " .. tostring(Ball.x), 10, 30)
    love.graphics.print("Ball.Y: " .. tostring(Ball.y), 135, 30)
end
