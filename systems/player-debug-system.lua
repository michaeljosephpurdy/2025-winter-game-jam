local System = tiny.processingSystem()
System.filter = tiny.requireAll('player')

---@param props SystemProps
function System:initialize(props)
  self.mouse_state = props.mouse_state
  self.camera_state = props.camera_state
  self.push = props.push
end
---@param e PlayerEntity
function System:process(e, dt)
  love.graphics.print(tostring(e.velocity), e.position.x, e.position.y - 20)
end

return System
