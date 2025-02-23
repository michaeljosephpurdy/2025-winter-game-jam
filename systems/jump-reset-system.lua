local JumpResetSystem = tiny.processingSystem()
JumpResetSystem.filter = tiny.requireAll('collidable', 'velocity', 'jumpable')

---@param e Jumpable | Velocity | Collidable
---@param dt number
function JumpResetSystem:process(e, dt)
  if e.jumpable.state ~= 'jumping' then
    return
  end
  if e.collidable.on_ground and e.velocity.y == 0 then
    e.jumpable.state = 'idle'
  end
end

return JumpResetSystem
