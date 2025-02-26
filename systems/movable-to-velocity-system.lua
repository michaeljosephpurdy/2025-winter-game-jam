local MovableToVelocitySystem = tiny.processingSystem()

---@param e Movable | Velocity
function MovableToVelocitySystem:filter(e)
  return e.movable and e.velocity
end

---@param props SystemProps
function MovableToVelocitySystem:initialize(props)
  self.friction_vector = vector(0.89, 1)
  self.game_state = props.game_state
end

---@param e Movable | Velocity
function MovableToVelocitySystem:process(e, dt)
  if self.game_state.state ~= 'PLAY' then
    return
  end
  if e.movable.paused then
    e.velocity = vector(0, 0)
    return
  end
  if e.movable.move_forward then
    e.velocity.x = e.velocity.x + e.movable.acceleration
  elseif e.movable.move_backward then
    e.velocity.x = e.velocity.x - e.movable.acceleration
  end
  e.velocity = e.velocity * self.friction_vector
end

return MovableToVelocitySystem
