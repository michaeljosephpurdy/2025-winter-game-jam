local System = tiny.processingSystem()

---@param e Event
function System:filter(e)
  return e.event and (e.event.key_press or e.event.key_release)
end

---@param props SystemProps
function System:initialize(props)
  self.keyboard = props.keyboard_state
end

---@param e Event
function System:onAdd(e)
  if not e.event.keycode then
    return
  end
  if e.event.key_release then
    self.keyboard:release(e.event.keycode)
  else
    self.keyboard:push(e.event.keycode)
  end
end

function System:postWrap()
  self.keyboard:reset()
end

return System
