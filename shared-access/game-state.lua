---@class GameState
---@field state 'PLAY' | 'PAUSE' | 'RESTART'
local GameState = class('GameState') ---[[@as GameState]]

function GameState:initialize()
  self.state = 'PLAY'
  ---@type ActionType[]
  self.actions = {}
  self.current_action_index = 1
  self.restart_timer = 0
end

---@return ActionType | nil
function GameState:get_action()
  if #self.actions == 0 then
    return nil
  end
  local new_actions = {}
  local action = nil
  for i = 1, #self.actions do
    if i == self.current_action_index then
      action = self.actions[i]
    else
      table.insert(new_actions, self.actions[i])
    end
  end
  self.actions = new_actions
  if self.current_action_index > #self.actions then
    self.current_action_index = #self.actions
  end
  return action
end

function GameState:set_actions(actions)
  self.actions = {}
  for _, action in pairs(actions or {}) do
    table.insert(self.actions, action)
  end
  self.current_action_index = 1
end

function GameState:toggle_controls()
  self.controls_locked = not self.controls_locked
end

function GameState:are_controls_locked()
  return self.controls_locked
end

function GameState:next_action()
  self.current_action_index = self.current_action_index + 1
  if self.current_action_index > #self.actions then
    self.current_action_index = 1
  end
end

function GameState:previous_action()
  self.current_action_index = self.current_action_index - 1
  if self.current_action_index < 1 then
    self.current_action_index = #self.actions
  end
end

return GameState
