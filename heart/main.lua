---@diagnostic disable: undefined-global, duplicate-set-field

Ball = {
    x = 0,
    y = 0,
    radius = 15,
    speed = 200,
    movingToCenter = true,
    t = 0
}

function love.load()
    Largura, Altura = love.graphics.getDimensions()
    CenterX = Largura / 2
    CenterY = Altura / 2
    Ball.x = Ball.radius
    Ball.y = Ball.radius
end

-- Função para desenhar um coração centralizado e proporcional
local function drawHeart(x, y, size)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(size, size)
    -- Coração: dois círculos e um triângulo, ajustados para formato correto
    love.graphics.setColor(1, 0.6, 0.8) -- rosa

    -- Círculo esquerdo
    love.graphics.ellipse("fill", -0.5, -0.3, 0.55, 0.6)
    -- Círculo direito
    love.graphics.ellipse("fill", 0.5, -0.3, 0.55, 0.6)
    -- Triângulo inferior
    love.graphics.polygon("fill", -1, -0.1, 0, 1.2, 1, -0.1)

    love.graphics.pop()
end

function love.update(dt)
    if Ball.movingToCenter then
        local dx = CenterX - Ball.x
        local dy = CenterY - Ball.y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < Ball.speed * dt then
            Ball.x = CenterX
            Ball.y = CenterY
            Ball.movingToCenter = false
            Ball.t = 0
        else
            Ball.x = Ball.x + (dx / dist) * Ball.speed * dt
            Ball.y = Ball.y + (dy / dist) * Ball.speed * dt
        end
    else
        Ball.t = Ball.t + dt
        local a = 100
        Ball.x = CenterX + a * math.cos(Ball.t) / (1 + math.sin(Ball.t) ^ 2)
        Ball.y = CenterY + a * math.sin(Ball.t) * math.cos(Ball.t) / (1 + math.sin(Ball.t) ^ 2)
    end
end

function love.draw()
    love.graphics.clear(0.7, 0.85, 1)
    local heartSize = math.min(Largura, Altura) * 0.18
    drawHeart(CenterX, CenterY, heartSize)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", Ball.x, Ball.y, Ball.radius)
    love.graphics.setColor(1, 1, 1)
end
