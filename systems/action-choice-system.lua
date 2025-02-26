local ActionChoiceSystem = tiny.system()

---@param props SystemProps
function ActionChoiceSystem:initialize(props)
  self.keyboard_state = props.keyboard_state
  self.game_state = props.game_state
end

---@param dt number
function ActionChoiceSystem:update(dt)
  if self.keyboard_state:is_key_just_released('d') or self.keyboard_state:is_key_just_released('right') then
    self.game_state:next_action()
  end
  if self.keyboard_state:is_key_just_released('a') or self.keyboard_state:is_key_just_released('left') then
    self.game_state:previous_action()
  end
end

return ActionChoiceSystem
