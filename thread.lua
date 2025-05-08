-- Função que será executada na thread
local function threadFunction()
    for i = 1, 5 do
        print("Executando na thread: " .. i)
        os.execute("timeout 1") -- Pausa de 1 segundo (use "sleep 1" no Linux/macOS e "timeout 1" no Windows)
    end
end

-- Criando a thread
local thread = coroutine.create(threadFunction)

-- Executando a thread
while coroutine.status(thread) ~= "dead" do
    coroutine.resume(thread)
    print("Executando no programa principal...")
    os.execute("timeout 1")
end

print("Thread finalizada!")
