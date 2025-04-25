-- Lua Language - Introdução

-- Compilar e Executar:
-- lua54 <nome_arquivo>.lua

-- Variáveis
local nome = 'Gabriel'
local idade = 22

-- Condições
if idade > 18 then
    print('Maior de idade')
else
    print('Menor de idade')
end

-- Loop
for i=0, 5 do
    print('Numero: ', i)
end

-- Função
local function saudacao(nome)
    print('Ola ' .. nome)
end

saudacao('Gabriel')

-- Objeto
local pessoa = {nome = "Marcus", idade = 27}

print(pessoa.nome)

--[[
-- LÖVE2D - Introdução
-- Printar dados
function love.draw()
    local largura, altura = love.graphics.getDimensions()
    love.graphics.print("Resolução atual: " .. largura .. "x" .. altura, largura/2, altura/2)
end

-- Carregar imagem
function love.load()
    img = love.graphics.newImage("src/img.png")
end

-- Printar imagem
function love.draw()
    love.graphics.draw(img, 300, 200)
end

-- Áudio
function love.load()
    som = love.audio.newSource("src/audio.mp3")
    love.audio.play(som)
end
]]
