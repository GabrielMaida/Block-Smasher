---@diagnostic disable: undefined-global

-- Carrega a biblioteca LOVE2D
function love.load()
    -- Armazena largura e altura da tela
    Largura, Altura = love.graphics.getDimensions()

    -- Configuração da bolinha
    Ball = {
        x = 0,
        y = 0,
        radius = 15,
        speedX = 40,
        speedY = 0
    }
end

-- Atualiza a lógica do jogo
function love.update(dt)
    --[[ while Ball.x < (Largura - Ball.radius) do

    end ]]

    Ball.x = Ball.x + Ball.speedX * dt
    Ball.y = Ball.y + Ball.speedY * dt
end

-- Desenha os elementos na tela
function love.draw()
    -- Desenha a bolinha
    love.graphics.circle("fill", Ball.x + Ball.radius, Ball.y + Ball.radius, Ball.radius)
end
