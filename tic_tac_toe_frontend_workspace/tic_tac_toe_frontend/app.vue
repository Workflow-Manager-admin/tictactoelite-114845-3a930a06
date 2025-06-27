<template>
  <div class="container">
    <header class="header">
      <h1>Tic Tac Toe</h1>
    </header>
    <section class="game-info">
      <p v-if="gameStatus==='ongoing'" class="turn-text">
        <span :style="{ color: currentPlayer==='X' ? primary : accent }">Player {{ currentPlayer }}</span>'s Turn
      </p>
      <p v-else class="outcome-text">
        <span v-if="gameStatus==='win'" class="win">
          <span :style="{ color: winner==='X' ? primary : accent }">Player {{ winner }}</span> wins!
        </span>
        <span v-else-if="gameStatus==='draw'" class="draw">
          It's a draw!
        </span>
      </p>
    </section>
    <main class="board-wrapper">
      <div class="board" :class="{ ended: gameStatus!=='ongoing' }" role="grid" aria-label="Tic Tac Toe Board">
        <button
          v-for="(cell, idx) in board"
          :key="idx"
          class="cell"
          :style="getCellStyle(cell)"
          :disabled="cell || gameStatus!=='ongoing'"
          @click="makeMove(idx)"
          role="gridcell"
          :aria-label="cell ? (cell==='X'?'Player X':'Player O') : 'Empty'"
        >
          {{ cell }}
        </button>
      </div>
    </main>
    <section class="controls">
      <button class="reset-btn" @click="resetGame">Restart Game</button>
    </section>
    <footer class="footer">
      <small>Minimalist two-player Tic Tac Toe &copy; 2024</small>
    </footer>
  </div>
</template>

<script setup lang="ts">
// PUBLIC_INTERFACE
/**
 * Tic Tac Toe Gameboard logic and UI, Nuxt3
 * Features: two-player local, clear outcome, reset, responsive, minimal styled with palette.
 */
import { ref, computed } from 'vue'

const primary = '#2D8CFF'
const accent = '#FFD700'
const secondary = '#121212'

const emptyBoard = () => Array(9).fill('')

const board = ref<string[]>(emptyBoard())
const currentPlayer = ref<'X'|'O'>('X')
const gameStatus = ref<'ongoing'|'win'|'draw'>('ongoing')
const winner = ref<''|'X'|'O'>('')

function checkWinner(bd: string[]): ''|'X'|'O' {
  const lines = [
    [0,1,2], [3,4,5], [6,7,8], // rows
    [0,3,6], [1,4,7], [2,5,8], // cols
    [0,4,8], [2,4,6]           // diags
  ]
  for (const [a,b,c] of lines) {
    if (bd[a] && bd[a] === bd[b] && bd[a] === bd[c]) {
      return bd[a] as 'X'|'O'
    }
  }
  return ''
}

// PUBLIC_INTERFACE
function makeMove(idx: number) {
  if (!board.value[idx] && gameStatus.value === 'ongoing') {
    board.value[idx] = currentPlayer.value
    const w = checkWinner(board.value)
    if (w) {
      gameStatus.value = 'win'
      winner.value = w
    } else if (board.value.every(cell => cell)) {
      gameStatus.value = 'draw'
    } else {
      currentPlayer.value = currentPlayer.value === 'X' ? 'O' : 'X'
    }
  }
}

// PUBLIC_INTERFACE
function resetGame() {
  board.value = emptyBoard()
  currentPlayer.value = 'X'
  gameStatus.value = 'ongoing'
  winner.value = ''
}

// PUBLIC_INTERFACE
function getCellStyle(cell: string) {
  if (cell === 'X') return { color: primary }
  if (cell === 'O') return { color: accent }
  return { color: secondary }
}
</script>

<style scoped>
:root {
  --primary: #2D8CFF;
  --accent: #FFD700;
  --secondary: #121212;
  --light-bg: #FAFAFB;
  --border: #E3E7F1;
  --cell-hover: #eaf3ff;
}

body, .container {
  min-height: 100vh;
  background: var(--light-bg);
  color: var(--secondary);
  margin: 0;
  font-family: 'Inter', 'SF Pro', Arial, sans-serif;
}

.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2.5vh 0;
  min-height: 100vh;
  box-sizing: border-box;
  background: var(--light-bg);
}

.header {
  text-align: center;
  width: 100%;
  padding: 0.5rem 0 .75rem 0;
  margin-bottom: .5rem;
}

.header h1 {
  font-weight: 700;
  font-size: 2.1rem;
  letter-spacing: 1px;
  color: var(--primary);
  margin: 0;
}

.game-info {
  text-align: center;
  min-height: 2.2em;
}
.turn-text {
  font-size: 1.12rem;
  letter-spacing: .5px;
}
.win, .draw {
  font-size: 1.14rem;
  font-weight: 600;
  letter-spacing: .5px;
}

.board-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100vw;
  margin: 1.3rem 0 0.5rem 0;
}

.board {
  display: grid;
  grid-template-columns: repeat(3, 82px);
  grid-template-rows: repeat(3, 82px);
  gap: 7.5px;
  border-radius: 16px;
  background: #fff;
  box-shadow: 0 1px 10px rgba(45,140,255,0.05);
  padding: 13px;
  border: 1.5px solid var(--border);
  transition: background 0.2s;
}
.board.ended {
  opacity: 0.96;
  filter: grayscale(0.04) brightness(0.98);
}
.cell {
  width: 82px; height: 82px;
  border-radius: 13px;
  border: 1.5px solid var(--border);
  font-size: 2.2rem;
  font-weight: 600;
  background: #fff;
  cursor: pointer;
  outline: none;
  transition: background 0.15s, box-shadow 0.2s;
}
.cell:enabled:hover {
  background: var(--cell-hover);
  box-shadow: 0 0 0 2px var(--primary, #2D8CFF, #FFD700, #121212);
}
.cell:disabled {
  cursor: not-allowed;
  background: #f6f6f9;
  opacity: 0.77;
}

.controls {
  width: 100%;
  display: flex;
  justify-content: center;
  margin-top: 1.7rem;
}

.reset-btn {
  padding: 0.5rem 1.5rem;
  font-size: 1rem;
  font-family: inherit;
  font-weight: 600;
  border-radius: 9px;
  border: none;
  background: linear-gradient(90deg, var(--primary), var(--accent));
  color: #fff;
  box-shadow: 0 2px 8px rgba(45,140,255,0.07);
  cursor: pointer;
  transition: background 0.2s, color 0.15s, transform 0.12s;
  letter-spacing: 0.25px;
}
.reset-btn:active {
  transform: translateY(1.5px) scale(0.98);
}

.footer {
  margin-top: auto;
  padding: 1.2em 0 0.95em 0;
  width: 100%;
  text-align: center;
  color: #727880;
  font-size: .96em;
  font-family: inherit;
}

/* Responsive design */
@media (max-width: 600px) {
  .board {
    grid-template-columns: repeat(3, 22vw);
    grid-template-rows: repeat(3, 22vw);
    padding: 2vw;
    gap: 2vw;
  }
  .cell {
    width: 22vw; height: 22vw;
    font-size: 2.5rem;
  }
  .board-wrapper {
    margin: 2vw 0;
  }
}
</style>
