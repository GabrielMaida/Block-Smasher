# Block Smasher

A brick-breaker game made in **Lua** with the **LÖVE** framework.

**Developed by:** [Gabriel Antônio Maida](https://github.com/GabrielMaida)

**Assets by:** [Bhernardo Ramos Vieira](https://github.com/bhernardo17)

**_UNICESUSC - 2025_**

**_Florianópolis, Santa Catarina_**

---

## 1. Concept

**Block Smasher** is a reimagining of the classic brick-breaker game, developed with a focus on creating a fun and visually pleasing arcade experience. The player controls a paddle at the bottom of the screen to bounce a ball and destroy all the blocks at the top.

---

## 2. Technologies

-   **Language:** [Lua](https://www.lua.org/)
-   **Framework:** [LÖVE2D](https://love2d.org/)

---

## 3. How to Run

### Requirements

-   [LÖVE2D](https://love2d.org/) (version 11.5 or higher)
-   [Lua](https://www.lua.org/)

### Steps

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/GabrielMaida/Block-Smasher
    cd Block-Smasher
    ```

2.  **Run the game:**
    With LÖVE installed, simply run the following command in the project root:
    ```bash
    love .
    ```

---

## 4. Requirements

The project requirements are divided into functional and non-functional, detailing the main expected features of the game.

### 4.1 Functional Requirements

1.  **Paddle Movement:** Allows the player to move the paddle horizontally (using the keyboard arrows `←`/`→` or `A`/`D`) to intercept the ball.
2.  **Ball Launch:** After a start timer (3 seconds), the ball is launched at an initial angle, directed towards the blocks.
3.  **Ball Collision:** The ball must bounce off when colliding with the paddle, walls, or blocks.
4.  **Block Destruction:** When a ball hits a block, it is destroyed.
5.  **Win and Loss Conditions:** The game ends and displays a victory message ("Victory!") when all blocks are destroyed, or a game over message ("Game Over!") if the ball passes the paddle.
6.  **Start Menu:** The game must feature a start menu with interactive buttons ("Start Game", "Exit Game").

### 4.2 Non-Functional Requirements

-   **Performance:** The game must run smoothly with a fast response time.
-   **Modularity:** The code must be modular to easily support new implementations.
-   **Usability:** The interface must be simple and intuitive, with visual and auditory feedback.
-   **Code Clarity:** The code must follow good programming practices to facilitate maintenance.

---

## 5. Use Cases

### Case 1: Paddle Movement

-   **Actor:** Player
-   **Description:** The player moves the paddle horizontally using the keyboard arrows (`←`/`→`) or keys (`A`/`D`) to intercept the ball.

### Case 2: Ball Launch

-   **Actor:** System
-   **Description:** After the 3-second timer, the ball is automatically launched at an initial angle.

### Case 3: Player Victory/Loss

-   **Actor:** Player
-   **Description:** Upon destroying all blocks, the game displays a "Victory!" message. If the ball goes off the bottom of the screen, the game displays "Game Over!". In both cases, the player has the option to play again or exit.

---

## 6. Folder Structure

```bash
Block-Smasher/
├── assets/         # Contains images, sounds, and music
├── main.lua        # Contains the main source code
├── conf.lua        # LÖVE configuration file
├── .gitignore
├── LICENSE
└── README.md
```

---

## 7. Code Structure

The game is centered around a `Game` object that functions as a state machine, managing the menu, game, victory, and loss screens.

```lua
-- Main object that manages the game state
Game = {
    state = "menu", -- States: "menu", "game"
    winorlose = nil, -- Victory (1) or loss (0) screens

    start = function() end,      -- Starts a new game
    gameover = function() end,   -- Activates the game over screen
    victory = function() end,    -- Activates the victory screen
    menu = function() end        -- Returns to the main menu
}

-- Main LÖVE functions
function love.load() end         -- Loads assets and initializes variables
function love.update(dt) end     -- Updates game logic
function love.draw() end         -- Draws elements on the screen
function love.mousepressed(x, y, button) end -- Handles mouse clicks
```

---

## 8. Game Loop

The game flow is divided into states, ensuring that the logic and rendering of each screen are independent.

-   **`love.load()`**: Loads all resources and prepares the initial game state (menu).
-   **`love.update(dt)`**: Checks the current state (`Game.state`) and calls the corresponding update function (`UpdateMenu`, `UpdateGame`).
-   **`love.draw()`**: Based on the state, draws the appropriate screen (`DrawMenu`, `DrawGame`) and the victory/loss screens.
