local GameStateToggleSystem = tiny.system()

---@param props SystemProps
function GameStateToggleSystem:initialize(props)
  self.game_state = props.game_state
  self.level_info = props.level_information
  self.keyboard_state = props.keyboard_state
  self.just_restarted = false
end

function GameStateToggleSystem:update(dt)
  if self.keyboard_state:is_key_down('r') then
    if self.game_state.state ~= 'RESTART' and not self.just_restarted then
      self.game_state.restart_timer = self.game_state.restart_timer + dt
      if self.game_state.restart_timer > 1 then
        self.just_restarted = true
        self.game_state.state = 'RESTART'
      end
    end
  else
    self.game_state.restart_timer = 0
    self.just_restarted = false
  end
  if self.game_state.state == 'RESTART' then
    self.game_state.restart_timer = 0
    self.world:clearEntities()
    ---@type Event
    local event = {
      event = {
        level_id = self.level_info.level_id,
        load_tile_map = true,
      },
    }
    tiny_world:addEntity(event)
  end
  if not self.keyboard_state:is_key_just_released('space') then
    return
  end
  if self.game_state.state == 'PLAY' then
    self.game_state.state = 'PAUSE'
  else
    self.game_state.state = 'PLAY'
  end
end

return GameStateToggleSystem
