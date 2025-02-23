local MovableDeltaPositionSystem = tiny.processingSystem()
MovableDeltaPositionSystem.filter = tiny.requireAll('movable', 'delta_position')

---@param e Movable | DeltaPosition
function MovableDeltaPositionSystem:process(e, dt)
  if e.movable.move_forward then
    e.delta_position.x = 1
  elseif e.movable.move_backward then
    e.delta_position.x = -1
  else
    e.delta_position.x = 0
  end
end

return MovableDeltaPositionSystem
