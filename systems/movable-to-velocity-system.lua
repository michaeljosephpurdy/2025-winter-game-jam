local MovableToVelocitySystem = tiny.processingSystem()
MovableToVelocitySystem.filter = tiny.requireAll('movable', 'velocity')

---@param props SystemProps
function MovableToVelocitySystem:initialize(props)
  self.friction_vector = vector(0.89, 1)
end

---@param e Movable | Velocity
function MovableToVelocitySystem:process(e, dt)
  if e.movable.move_forward then
    e.velocity.x = e.velocity.x + e.movable.acceleration
  elseif e.movable.move_backward then
    e.velocity.x = e.velocity.x - e.movable.acceleration
  end
  e.velocity.x = math.clamp(-e.movable.max_speed, e.velocity.x, e.movable.max_speed)
  e.velocity = e.velocity * self.friction_vector
end

return MovableToVelocitySystem
