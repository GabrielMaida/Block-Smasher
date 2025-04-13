function love.draw()
    local largura, altura = love.graphics.getDimensions()
    love.graphics.print("Resolução atual: " .. largura .. "x" .. altura, largura/2, altura/2)
end