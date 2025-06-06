# Block Smasher - Lua/LÖVE

**ADS41 - Gabriel Antônio Maida, Leonardo Peron Krause, Pedro Henrique Sardá, Luis Felipe Barbosa, Bhernardo Ramos Vieira**

**_UNICESUSC - 2025_**

---

## Índice

-   [Block Smasher - Lua/LÖVE](#block-smasher---lualöve)
    -   [Índice](#índice)
    -   [1. Conceito](#1-conceito)
    -   [2. Tecnologias/Referências](#2-tecnologiasreferências)
    -   [3. Como Executar](#3-como-executar)
        -   [LÖVE2D](#löve2d)
        -   [Lua](#lua)
    -   [4. Requisitos](#4-requisitos)
        -   [4.1 Requisitos Funcionais](#41-requisitos-funcionais)
        -   [4.2 Requisitos Não-Funcionais](#42-requisitos-não-funcionais)
    -   [5. Casos de Uso](#5-casos-de-uso)
        -   [Caso 1: Movimentação da Barra](#caso-1-movimentação-da-barra)
        -   [Caso 2: Lançamento da Bolinha](#caso-2-lançamento-da-bolinha)
        -   [Caso 3: Vitória do Jogador](#caso-3-vitória-do-jogador)
        -   [Caso 4: Sincronização de Bolinhas (Programação Distribuída)](#caso-4-sincronização-de-bolinhas-programação-distribuída)
    -   [6. Arquitetura e Fluxo do Sistema](#6-arquitetura-e-fluxo-do-sistema)
        -   [6.1. Menu Inicial](#61-menu-inicial)
        -   [6.2. Game Loop](#62-game-loop)
        -   [6.3. Módulo Distribuído](#63-módulo-distribuído)
        -   [6.4. Diagrama Resumido do Fluxo](#64-diagrama-resumido-do-fluxo)
    -   [7. Estrutura de Pastas](#7-estrutura-de-pastas)
    -   [8. Estrutura do Código](#8-estrutura-do-código)
    -   [9. Apresentações](#9-apresentações)
        -   [Avaliação N1](#avaliação-n1)
        -   [Avaliação N2](#avaliação-n2)
        -   [Avaliação N3](#avaliação-n3)

---

## 1. Conceito

O **Block Smasher** é um jogo arcade desenvolvido em Lua com o framework LÖVE, inspirado no clássico "Quebra-Tijolos", que integra conceitos de **programação distribuída** e **paralelismo**, permitindo que diferentes partes do sistema funcionem de forma coordenada, mesmo em processos distintos ou locais diferentes, e possibilitando a execução simultânea de múltiplas instâncias de elementos do jogo, como objetos ou entidades independentes, tornando a experiência mais dinâmica.

---

## 2. Tecnologias/Referências

-   **Linguagem de Programação:** [Lua](https://www.lua.org/)
-   **Framework:** [LÖVE](https://www.love2d.org/)
-   **Conceito de Programação Distribuída:** [Referência para estudo](https://dev.to/daviducolo/distributed-programming-from-basics-to-advanced-concepts-5h66)

---

## 3. Como Executar

### LÖVE2D

Para rodar o projeto com LÖVE2D, basta executar o seguinte comando na raiz do projeto:

```
love .
```

### Lua

Para rodar um arquivo Lua, utilize o seguinte comando:

```
lua <arquivo>.lua
```
ou
```
lua5.<versão> <arquivo>.lua
```

> Obs: Substitua `<arquivo>` pelo nome do arquivo que deseja executar.

---

## 4. Requisitos

Os requisitos do projeto estão divididos em funcionais e não-funcionais, detalhando as principais funcionalidades esperadas do jogo e as características de qualidade que devem ser atendidas. Estes requisitos servem como base para o desenvolvimento.

### 4.1 Requisitos Funcionais

1. **Movimentação da Barra:**  
   Permite que o jogador mova a barra horizontalmente (usando as setas do teclado) para interceptar a(s) bolinha(s).

2. **Lançamento da Bolinha:**  
   Ao pressionar a tecla espaço, a bolinha é lançada em um ângulo inicial (evitando movimento linear), direcionada para os blocos.

3. **Múltiplas Bolinhas Ativas:**  
   Possibilidade de ter mais de uma bolinha simultaneamente em jogo, reforçando o aspecto da programação distribuída.

4. **Colisão da Bolinha:**  
   As bolinhas devem ricochetear ao colidir com a barra, as paredes ou os blocos.

5. **Destruição de Blocos e Pontuação:**  
   Quando uma bolinha atinge um bloco, este é destruído e o jogador ganha pontos. A pontuação é exibida dinamicamente em tempo real, sem ser armazenada após o término da partida.

6. **Condição de Vitória:**  
   O jogo termina e exibe uma mensagem de vitória quando todos os blocos são destruídos.

7. **Sincronização entre Bolinhas:**  
   O estado (posição, direção, velocidade) das bolinhas deve ser compartilhado entre processos ou dispositivos conectados, garantindo uma experiência consistente em tempo real.

8. **Menu de Início:**  
   O jogo deve apresentar um menu inicial com arte de fundo, servindo como porta de entrada para o início da partida.

### 4.2 Requisitos Não-Funcionais

-   **Desempenho:** O jogo deve rodar de maneira fluida e com tempo de resposta rápido.
-   **Modularidade:** O código deve ser modular para suportar facilmente novas implementações e escalabilidade.
-   **Usabilidade:** A interface deve ser simples e intuitiva, sem a necessidade de instruções complexas.
-   **Clareza do Código:** O código deve seguir boas práticas de programação, incluindo comentários e organização lógica, para facilitar a manutenção e futuras colaborações.

---

## 5. Casos de Uso

### Caso 1: Movimentação da Barra

-   **Ator:** Jogador
-   **Descrição:** O jogador move a barra horizontalmente utilizando as setas do teclado. A barra se posiciona de acordo com a direção do movimento, permitindo interceptar a bolinha.

### Caso 2: Lançamento da Bolinha

-   **Ator:** Jogador
-   **Descrição:** Após posicionar a barra, o jogador pressiona a tecla espaço, lançando a bolinha em um ângulo que a direciona para os blocos.

### Caso 3: Vitória do Jogador

-   **Ator:** Jogador
-   **Descrição:** Ao destruir todos os blocos, o jogo exibe uma mensagem de vitória e encerra a partida, oferecendo ao jogador a opção de reiniciar.

### Caso 4: Sincronização de Bolinhas (Programação Distribuída)

-   **Ator:** Servidor e Clientes
-   **Descrição:** Ao lançar ou atualizar o estado de uma bolinha, os dados são compartilhados entre os processos ou dispositivos conectados, mantendo a consistência do jogo em tempo real.

---

## 6. Arquitetura e Fluxo do Sistema

A arquitetura do **Block Smasher** está dividida em três módulos principais que garantem a simplicidade e o foco no uso de programação distribuída:

### 6.1. Menu Inicial

-   **Objetivo:**  
    Ao iniciar o jogo, é exibido um menu inicial com uma arte de fundo. Esse menu serve de porta de entrada e aguarda que o usuário clique para iniciar a partida ou outra opção.

-   **Funcionalidades:**
    -   Exibição de uma arte de fundo atrativa.
    -   Interface com um botão ou área clicável para transição ao estado de jogo ativo.

### 6.2. Game Loop

-   **Inicialização (`love.load()`):**  
    Configura as dimensões da tela e define as propriedades iniciais da bolinha (posição, raio, velocidade, etc.).

-   **Ciclo Principal:**
    -   **`love.update(dt)`:**  
        Atualiza continuamente a posição da bolinha (ou bolinhas) com base em sua velocidade e tempo delta. Neste ponto também é integrada a lógica de sincronização para garantir que as atualizações sejam distribuídas entre os nós conectados.
    -   **`love.draw()`:**  
        Renderiza na tela a bolinha, a barra (controlada pelo jogador) e os blocos, refletindo o estado atualizado da partida.

### 6.3. Módulo Distribuído

-   **Objetivo:**  
    Sincronizar o estado das bolinhas entre processos ou dispositivos, demonstrando os conceitos de paralelismo e comunicação distribuída.

-   **Funcionamento:**
    -   **Envio e Atualização de Dados:**  
        Quando uma bolinha é lançada ou seu estado é alterado, os dados correspondentes (posição, direção e velocidade) são enviados a um sistema distribuído que os retransmite aos demais nós.
    -   **Recepção de Dados:**  
        Cada nó integrante recebe as atualizações e ajusta o estado local das bolinhas, garantindo uma experiência coesa e em tempo real para todos os participantes.

### 6.4. Diagrama Resumido do Fluxo

```
                           +---------------------+
                           |    Menu Inicial     |
                           | (Arte de Fundo e UI)|
                           +---------------------+
                                     |
                            Clique para iniciar
                                     |
                                     v
                           +---------------------+
                           |   Estado de Jogo    |
                           |  (Game Loop Ativo)  |
                           +---------------------+
                                     |
                     +---------------+----------------+
                     |                                |
               love.load()                      Inicializa variáveis
                     |                                |
                     v                                v
               +------------+                  +-------------+
               | love.update|<-----------------|Sincronização|-----> Outros processos
               +------------+                  | Distribuída |
                     |                         +-------------+
                     v
               +------------+
               | love.draw  |
               +------------+
```

---

## 7. Estrutura de Pastas

```
Block-Smasher/
├── docs/
├── .gitignore
├── conf.lua
├── main.lua
├── thread.lua
├── LICENSE
└── README.md

```

---

## 8. Estrutura do Código

Exemplo básico de estrutura das funções principais do LÖVE2D em Lua:

```lua
-- Função chamada ao iniciar o jogo
function love.load()
    -- Inicialização de variáveis, carregamento de imagens, sons, etc.
end

-- Função chamada a cada frame para atualizar a lógica do jogo
function love.update(dt)
    -- Atualização de posições, verificações de colisão, etc.
end

-- Função chamada a cada frame para desenhar na tela
function love.draw()
    -- Desenho de sprites, textos, formas, etc.
end
```

---

## 9. Apresentações

### Avaliação N1

-   Linguagem e justificativa da escolha
-   Overview do projeto
-   Explicação dos requisitos funcionais
-   Detalhamento dos casos de uso
-   Apresentação dos slides
    **Data da Apresentação:** 17/04

### Avaliação N2

-   Andamento do projeto
-   Arquitetura do sistema e desenho do fluxo
-   Apresentação dos slides  
    **Data da Apresentação:** 15/05

### Avaliação N3

-   (Avaliação a ser definida)  
    **Data da Apresentação:** (A definir)
