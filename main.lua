---@diagnostic disable: undefined-global

-- Carrega a biblioteca LOVE2D
function love.load()
    -- Configuração da bolinha
    Ball = {
        x = 0,
        y = 0,
        radius = 15,
        speedX = 200,
        speedY = -200
    }
end

-- Atualiza a lógica do jogo
function love.update(dt)
    -- Atualiza a posição da bolinha
    ball.x = ball.x + ball.speedX * dt
    ball.y = ball.y + ball.speedY * dt
end

-- Desenha os elementos na tela
function love.draw()
    -- Armazena largura e altura da tela
    local largura, altura = love.graphics.getDimensions()

    -- Desenha a bolinha
    love.graphics.circle("fill", Ball.x + Ball.radius, Ball.y + Ball.radius, Ball.radius)
end
