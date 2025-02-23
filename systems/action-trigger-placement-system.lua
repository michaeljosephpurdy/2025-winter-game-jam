local ActionTriggerPlacementSystem = tiny.system()

---@param props SystemProps
function ActionTriggerPlacementSystem:initialize(props)
  self.mouse_state = props.mouse_state
  self.entity_factory = props.entity_factory
  self.camera_state = props.camera_state
end

function ActionTriggerPlacementSystem:update(dt)
  if not self.mouse_state:is_left_click_just_relased() then
    return
  end
  -- check x and y for valid value
  -- spawn corresponding entity
  local mouse_x, mouse_y = self.mouse_state:get_position()
  local action_x, action_y = self.camera_state:to_game_coord(mouse_x, mouse_y)
  local action = self.entity_factory:build({
    x = math.floor(action_x / 16) * 16,
    y = math.floor(action_y / 16) * 16,
    id = 'JUMP_ACTION',
  })[1]
  self.world:addEntity(action)
end

return ActionTriggerPlacementSystem
