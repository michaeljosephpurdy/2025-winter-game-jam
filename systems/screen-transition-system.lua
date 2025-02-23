local ScreenTransitionSystem = tiny.processingSystem()
ScreenTransitionSystem.filter = tiny.requireAll('screen_transition_event')

---@param props SystemProps
function ScreenTransitionSystem:initialize(props)
  self.screen_info = props.screen_information
end

---@param e ScreenTransitionEvent
function ScreenTransitionSystem:onAdd(e)
  e.screen_transition_event.progress = 0
  e.screen_transition_event.fade_out = not e.screen_transition_event.fade_in
end

---@param e ScreenTransitionEvent
function ScreenTransitionSystem:process(e, dt)
  local event = e.screen_transition_event
  event.progress = event.progress + dt
  local alpha = event.progress / event.transition_time
  if event.fade_in then
    alpha = 1 - alpha
  end
  alpha = math.clamp(0, alpha, 1)
  love.graphics.pop()
  love.graphics.setColor(0, 0, 0, alpha)
  love.graphics.rectangle('fill', 0, 0, self.screen_info.width, self.screen_info.height)
  love.graphics.push()
  local done = event.progress > event.transition_time
  if done and event.fade_out and event.level_to_load then
    self.world:clearEntities()
    self.world:addEntity({
      event = {
        load_tile_map = true,
      },
      level_id = event.level_to_load,
    })
    return
  end
  if done then
    self.world:removeEntity(e)
  end
end

---@param e ScreenTransitionEvent
function ScreenTransitionSystem:onRemove(e)
  if e.screen_transition_event.fade_in then
    return
  end
  ---@type ScreenTransitionEvent
  local fade_in_event = {
    screen_transition_event = {
      transition_time = e.screen_transition_event.transition_time,
      fade_in = true,
    },
  }
  self.world:addEntity(fade_in_event)
  love.graphics.push()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle('fill', 0, 0, self.screen_info.width, self.screen_info.height)
  love.graphics.pop()
end

return ScreenTransitionSystem
