local EntityLevelBoundarySystem = tiny.processingSystem()

---@param e Position | Player
function EntityLevelBoundarySystem:filter(e)
  return e.position and not e.player
end

---@param props SystemProps
function EntityLevelBoundarySystem:initialize(props)
  self.level_info = props.level_information
end

---@param e Position
function EntityLevelBoundarySystem:process(e, dt)
  if
    e.position.x >= self.level_info.top_left.x
    and e.position.x <= self.level_info.bottom_right.x
    and e.position.y >= self.level_info.top_left.y
    and e.position.y <= self.level_info.bottom_right.y
  then
    return
  end
  self.world:removeEntity(e)
end

return EntityLevelBoundarySystem
