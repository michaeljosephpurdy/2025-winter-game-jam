local MovablePlayerSystem = tiny.processingSystem()
MovablePlayerSystem.filter = tiny.requireAll('player')

---@param e PlayerEntity
function MovablePlayerSystem:process(e, dt)
  if e.collidable.left_wall then
    e.movable.move_forward = true
    e.movable.move_backward = false
  elseif e.collidable.right_wall then
    e.movable.move_forward = false
    e.movable.move_backward = true
  end
end

return MovablePlayerSystem
