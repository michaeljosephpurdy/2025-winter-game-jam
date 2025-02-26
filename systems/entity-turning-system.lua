local EntityTurningSystem = tiny.processingSystem()

---@param e Collidable | Movable
function EntityTurningSystem:filter(e)
  return e.collidable and e.movable
end

---@param e Collidable | Movable
function EntityTurningSystem:process(e, dt)
  if e.collidable.left_wall then
    e.movable.move_forward = true
    e.movable.move_backward = false
  elseif e.collidable.right_wall then
    e.movable.move_forward = false
    e.movable.move_backward = true
  end
end

return EntityTurningSystem
