local GravityApplicationSystem = tiny.processingSystem()

---@param e Velocity | Gravity
function GravityApplicationSystem:filter(e)
  return e.gravity and e.gravity.enabled and e.velocity
end

---@param props SystemProps
function GravityApplicationSystem:initialize(props)
  self.gravity = 10
  self.max_gravity = 400
  self.gravity_vector = vector(0, self.gravity)
end

---@param e Velocity | Gravity
function GravityApplicationSystem:process(e, dt)
  e.velocity = e.velocity + self.gravity_vector
  if e.velocity.y > self.max_gravity then
    e.velocity.y = self.max_gravity
  end
end

return GravityApplicationSystem
