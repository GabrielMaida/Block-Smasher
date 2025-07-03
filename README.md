# Block Smasher

Um jogo de quebra-tijolos feito em **Lua** com o framework **LÖVE**.

**Desenvolvido por:** Gabriel Antônio Maida, Leonardo Peron Krause, Pedro Henrique Sardá, Luis Felipe Barbosa, Bhernardo Ramos Vieira.

**_UNICESUSC - 2025_**

---

## Índice

- [1. Conceito](#1-conceito)
- [2. Tecnologias](#2-tecnologias)
- [3. Como Executar](#3-como-executar)
- [4. Requisitos](#4-requisitos)
- [5. Casos de Uso](#5-casos-de-uso)
- [6. Estrutura de Pastas](#6-estrutura-de-pastas)
- [7. Estrutura do Código](#7-estrutura-do-código)
- [8. Game Loop](#8-game-loop)
- [9. Apresentações](#9-apresentações)

---

## 1. Conceito

O **Block Smasher** é uma releitura do clássico jogo de quebra-tijolos, desenvolvido com foco em criar uma experiência arcade divertida e visualmente agradável. O jogador controla uma barra na parte inferior da tela para rebater uma bolinha e destruir todos os blocos na parte superior.

---

## 2. Tecnologias

-   **Linguagem:** [Lua](https://www.lua.org/)
-   **Framework:** [LÖVE](https://love2d.org/)

---

## 3. Como Executar

### Requisitos

-   [LÖVE](https://love2d.org/) (versão 11.5 ou superior)
-   [Lua](https://www.lua.org/)

### Passos

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/GabrielMaida/Block-Smasher
    cd Block-Smasher
    ```

2.  **Execute o jogo:**
    Com o LÖVE instalado, basta executar o seguinte comando na raiz do projeto:
    ```bash
    love .
    ```

---

## 4. Requisitos

Os requisitos do projeto estão divididos em funcionais e não-funcionais, detalhando as principais funcionalidades esperadas do jogo.

### 4.1 Requisitos Funcionais

1.  **Movimentação da Barra:**
    Permite que o jogador mova a barra horizontalmente (usando as setas do teclado `←`/`→` ou `A`/`D`) para interceptar a bolinha.

2.  **Lançamento da Bolinha:**
    Após um temporizador de início (3 segundos), a bolinha é lançada em um ângulo inicial, direcionada para os blocos.

3.  **Colisão da Bolinha:**
    A bolinha deve ricochetear ao colidir com a barra, as paredes ou os blocos.

4.  **Destruição de Blocos:**
    Quando uma bolinha atinge um bloco, este é destruído.

5.  **Condição de Vitória e Derrota:**
    O jogo termina e exibe uma mensagem de vitória ("Victory!") quando todos os blocos são destruídos, ou uma mensagem de derrota ("Game Over!") se a bolinha ultrapassar a barra.

6.  **Menu de Início:**
    O jogo deve apresentar um menu inicial com botões interativos ("Start Game", "Exit Game").

### 4.2 Requisitos Não-Funcionais

-   **Desempenho:** O jogo deve rodar de maneira fluida e com tempo de resposta rápido.
-   **Modularidade:** O código deve ser modular para suportar facilmente novas implementações.
-   **Usabilidade:** A interface deve ser simples e intuitiva, com feedback visual e sonoro.
-   **Clareza do Código:** O código deve seguir boas práticas de programação para facilitar a manutenção.

---

## 5. Casos de Uso

### Caso 1: Movimentação da Barra

-   **Ator:** Jogador
-   **Descrição:** O jogador move a barra horizontalmente utilizando as setas do teclado (`←`/`→`) ou as teclas (`A`/`D`) para interceptar a bolinha.

### Caso 2: Lançamento da Bolinha

-   **Ator:** Sistema
-   **Descrição:** Após o temporizador de 3 segundos, a bolinha é automaticamente lançada em um ângulo inicial.

### Caso 3: Vitória/Derrota do Jogador

-   **Ator:** Jogador
-   **Descrição:** Ao destruir todos os blocos, o jogo exibe uma mensagem de "Victory!". Se a bolinha sair da tela por baixo, o jogo exibe "Game Over!". Em ambos os casos, o jogador tem a opção de jogar novamente ou sair.

---

## 6. Estrutura de Pastas

```bash
Block-Smasher/
├── assets/         # Contém imagens, sons e músicas
├── main.lua        # Contém o código-fonte principal
├── conf.lua        # Arquivo de configuração do LÖVE
├── .gitignore
├── LICENSE
└── README.md
```

---

## 7. Estrutura do Código

O jogo é centralizado em um objeto `Game` que funciona como uma máquina de estados, gerenciando as telas de menu, jogo, vitória e derrota.

```lua
-- Objeto principal que gerencia o estado do jogo
Game = {
    state = "menu", -- Estados: "menu", "game"
    winorlose = nil, -- Telas de vitória (1) ou derrota (0)

    start = function() end,      -- Inicia uma nova partida
    gameover = function() end,   -- Ativa a tela de derrota
    victory = function() end,    -- Ativa a tela de vitória
    menu = function() end        -- Volta para o menu principal
}

-- Funções principais do LÖVE
function love.load() end         -- Carrega assets e inicializa variáveis
function love.update(dt) end     -- Atualiza a lógica do jogo
function love.draw() end         -- Desenha os elementos na tela
function love.mousepressed(x, y, button) end -- Lida com cliques do mouse
```

---

## 8. Game Loop

O fluxo do jogo é dividido em estados, garantindo que a lógica e a renderização de cada tela sejam independentes.

-   **`love.load()`**: Carrega todos os recursos e prepara o estado inicial do jogo (menu).
-   **`love.update(dt)`**: Verifica o estado atual (`Game.state`) e chama a função de atualização correspondente (`UpdateMenu`, `UpdateGame`).
-   **`love.draw()`**: Com base no estado, desenha a tela apropriada (`DrawMenu`, `DrawGame`) e as telas de vitória/derrota.

---

## 9. Apresentações

### Avaliação N1
-   Linguagem e justificativa da escolha
-   Overview do projeto
-   Apresentação dos slides

    **Data da Apresentação:** 📅17/04/2025

### Avaliação N2
-   Andamento do projeto
-   Arquitetura do sistema
-   Apresentação dos slides

    **Data da Apresentação:** 📅15/05/2025

### Avaliação N3
-   Apresentação Final

    **Data da Apresentação:** 📅03/07/2025