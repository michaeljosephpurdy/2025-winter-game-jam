---@class GameState
---@field state 'PLAY' | 'PAUSE'
---
local GameState = class('GameState') ---[[@as GameState]]

function GameState:initialize()
  self.state = 'PLAY'
end

function GameState:toggle_controls()
  self.controls_locked = not self.controls_locked
end

function GameState:are_controls_locked()
  return self.controls_locked
end

return GameState
