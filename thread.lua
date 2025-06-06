-- Função que será executada na thread
local function threadFunction()
    for i = 1, 5 do
        print("Executando na thread: " .. i)
        os.execute("sleep 1") -- Pausa de 1 segundo
    end
end

-- Criando a thread
local thread = coroutine.create(threadFunction)

-- Executando a thread
while coroutine.status(thread) ~= "dead" do
    coroutine.resume(thread)
    print("Executando no programa principal...")
    os.execute("sleep 1")
end

print("Thread finalizada!")
