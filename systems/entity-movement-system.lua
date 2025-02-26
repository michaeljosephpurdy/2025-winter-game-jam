local EntityMovementSystem = tiny.processingSystem()

---@param e Position | Velocity | DeltaPosition | FuturePosition
function EntityMovementSystem:filter(e)
  return e.position and e.velocity and e.delta_position and e.future_position
end

---@param e Position | Velocity | DeltaPosition | FuturePosition
function EntityMovementSystem:process(e, dt)
  e.future_position = e.position + (e.delta_position * e.velocity * dt)
end

return EntityMovementSystem
