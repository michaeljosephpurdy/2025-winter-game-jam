local System = tiny.processingSystem()
local keyboard_events = tiny.requireAny('key_press', 'key_release')
System.filter = tiny.requireAll(keyboard_events, 'is_event')

---@param props SystemProps
function System:initialize(props)
  self.keyboard = props.keyboard_state
end

function System:onAdd(e)
  if e.key_release then
    self.keyboard:release(e.keycode)
    if e.keycode == 'escape' then
      start_game()
    end
  else
    self.keyboard:push(e.keycode)
  end
end

return System
