local GravityApplicationSystem = tiny.processingSystem()

---@param e Velocity | Gravity
function GravityApplicationSystem:filter(e)
  return e.gravity and e.velocity and not e.gravity.disabled
end

---@param props SystemProps
function GravityApplicationSystem:initialize(props)
  self.gravity = 14
  self.max_gravity = 300
  self.gravity_vector = vector(0, self.gravity)
  self.game_state = props.game_state
end

---@param e Velocity | Gravity
function GravityApplicationSystem:process(e, dt)
  if self.game_state.state ~= 'PLAY' then
    return
  end
  e.velocity = e.velocity + self.gravity_vector
  if e.velocity.y > self.max_gravity then
    e.velocity.y = self.max_gravity
  end
end

return GravityApplicationSystem
