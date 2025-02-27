local EntityMovementSystem = tiny.processingSystem()

---@param e OldPosition | Position | Velocity | DeltaPosition | FuturePosition
function EntityMovementSystem:filter(e)
  return e.old_position and e.position and e.velocity and e.delta_position and e.future_position
end

---@param e OldPosition | Position | Velocity | DeltaPosition | FuturePosition
function EntityMovementSystem:process(e, dt)
  e.old_position = e.position:clone()
  local x = e.position.x + (e.delta_position.x * e.velocity.x * dt)
  local y = e.position.y + (e.velocity.y * dt)
  e.future_position = vector(x, y)
end

return EntityMovementSystem
