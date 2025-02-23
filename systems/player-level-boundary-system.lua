local PlayerLevelBoundarySystem = tiny.processingSystem()
PlayerLevelBoundarySystem.filter = tiny.requireAll('player', 'position')

---@param props SystemProps
function PlayerLevelBoundarySystem:initialize(props)
  self.level_info = props.level_information
end

function PlayerLevelBoundarySystem:onAdd(e)
  self.triggered = false
end

---@param e Position
function PlayerLevelBoundarySystem:process(e, dt)
  if self.triggered then
    return
  end
  if
    e.position.x >= self.level_info.top_left.x
    and e.position.x <= self.level_info.bottom_right.x
    and e.position.y >= self.level_info.top_left.y
    and e.position.y <= self.level_info.bottom_right.y
  then
    return
  end
  self.triggered = true
  ---@type ScreenTransitionEvent
  local event =
    { screen_transition_event = {
      level_to_load = self.level_info.level_id,
      transition_time = 0.5,
    } }
  self.world:addEntity(event)
end

return PlayerLevelBoundarySystem
