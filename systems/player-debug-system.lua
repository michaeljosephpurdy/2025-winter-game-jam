local PlayerDebugSystem = tiny.processingSystem()
PlayerDebugSystem.filter = tiny.requireAll('player')

---@param props SystemProps
function PlayerDebugSystem:initialize(props)
  self.mouse_state = props.mouse_state
  self.camera_state = props.camera_state
end

---@param e PlayerEntity
function PlayerDebugSystem:process(e, dt)
  --love.graphics.print(tostring(e.velocity), e.position.x, e.position.y - 20)
end

return PlayerDebugSystem
