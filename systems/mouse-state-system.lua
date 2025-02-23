local MouseStateSystem = tiny.system()

---@param props SystemProps
function MouseStateSystem:initialize(props)
  self.mouse_state = props.mouse_state
  self.camera_state = props.camera_state
end

function MouseStateSystem:update(dt)
  self.mouse_state:update()
end

return MouseStateSystem
