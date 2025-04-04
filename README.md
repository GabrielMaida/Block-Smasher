# Block Smasher - Lua/LÖVE  
ADS41 - Gabriel Antônio, Leonardo Peron, Pedro Henrique Sardá

*UNICESUSC - 2025*

---

## Conceito

O "Block Smasher" é um jogo arcade desenvolvido em Lua, inspirado no clássico estilo "Quebra-Tijolos". Sua principal inovação é a integração de conceitos de programação distribuída, permitindo a existência de múltiplas bolinhas simultaneamente durante a partida. O jogo apresenta uma barra controlada pelo jogador e blocos estrategicamente posicionados que devem ser destruídos. Ao pressionar a tecla espaço, o jogador lança uma bola em direção aos blocos, preferencialmente em ângulo, para evitar movimentos lineares. O objetivo final é simples: destruir todos os blocos.

---

## Pré-Requisitos

- O desenvolvimento será feito utilizando:  
  - Linguagem de programação **[Lua](https://www.lua.org/)**  
  - Framework de criação de jogos 2D **[LÖVE](https://www.love2d.org/)**  
- O projeto deve implementar conceitos de **[Programação Distribuída](https://dev.to/daviducolo/distributed-programming-from-basics-to-advanced-concepts-5h66)**.  

---

## Requisitos Funcionais

1. **Movimentação da Barra**:  
   O jogador deve ser capaz de mover a barra horizontalmente (esquerda e direita) usando as setas do teclado.  
2. **Lançamento da Bola**:  
   O jogador deve ser capaz de lançar uma bola com a tecla espaço, preferencialmente em um ângulo para evitar movimento linear.  
3. **Múltiplas Bolas Ativas**:  
   Deve ser possível ter mais de uma bola simultaneamente no jogo para simular o aspecto distribuído.  
4. **Colisão da Bola**:  
   As bolas devem ricochetear ao colidirem com a barra, as paredes ou os blocos.  
5. **Destruição de Blocos e Pontuação**:  
   Ao atingir os blocos, estes devem ser destruídos, e o jogador deve ganhar pontos. A pontuação deve ser exibida na tela em tempo real.  
6. **Condição de Vitória**:  
   O jogo deve terminar e indicar a vitória quando todos os blocos forem destruídos.  
7. **Pontuação em Tela**:  
   A pontuação do jogador será exibida dinamicamente durante o jogo, mas não será armazenada após o término da partida.  
8. **Sincronização entre Bolas**:  
   O estado das bolas deve ser sincronizado entre processos distribuídos para garantir consistência durante a partida.  

---

## Casos de Uso

### Caso 1: Movimentação da Barra  
**Ator:** Jogador  
**Descrição:**  
O jogador move a barra horizontalmente utilizando as setas do teclado.  
**Fluxo Principal:**  
1. O jogador pressiona a seta para a direita ou esquerda.  
2. A barra se move na direção correspondente, respeitando os limites da tela.  
3. O jogador ajusta a posição da barra para interceptar a bola.  

### Caso 2: Lançamento da Bola  
**Ator:** Jogador  
**Descrição:**  
O jogador lança uma bola em direção aos blocos pressionando a tecla espaço.  
**Fluxo Principal:**  
1. O jogador posiciona a barra.  
2. O jogador pressiona a tecla espaço.  
3. A bola é lançada em um ângulo inicial, movendo-se em direção aos blocos.  

### Caso 3: Vitória do Jogador  
**Ator:** Jogador  
**Descrição:**  
O jogador vence o jogo ao destruir todos os blocos presentes no cenário.  
**Fluxo Principal:**  
1. O jogador acerta os blocos com a(s) bola(s).  
2. Quando todos os blocos são destruídos, o sistema exibe uma mensagem de vitória.  
3. O jogo termina e o jogador tem a opção de reiniciar a partida.  

### Caso 4: Sincronização de Bolas (Programação Distribuída)  
**Ator:** Servidor e Clientes  
**Descrição:**  
As bolas são sincronizadas entre diferentes processos ou dispositivos conectados.  
**Fluxo Principal:**  
1. O jogador lança uma bola.  
2. O estado da bola (posição, direção, velocidade) é compartilhado entre os processos ou máquinas conectadas.  
3. As posições das bolas são atualizadas em tempo real nos dispositivos conectados, garantindo consistência.  

---

## Apresentação

**Data de Apresentação:** 17/04  

### Tópicos de Avaliação:  
- Sobre a linguagem  
- Por que da escolha dela  
- Overview do projeto  
- Explicação dos Requisitos Funcionais  
- Explicação dos Casos de Uso  