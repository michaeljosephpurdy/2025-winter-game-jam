local EntityMovementSystem = tiny.processingSystem()
EntityMovementSystem.filter = tiny.requireAll('position', 'velocity', 'delta_position', 'future_position')

---@param e Position | Velocity | DeltaPosition | FuturePosition
function EntityMovementSystem:process(e, dt)
  e.future_position = e.position + (e.delta_position + (e.velocity * dt))
end

return EntityMovementSystem
