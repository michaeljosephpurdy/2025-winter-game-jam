local CollisionDrawingSystem = tiny.processingSystem()
CollisionDrawingSystem.filter = tiny.requireAll('position', 'collidable')

---@param e Position | Collidable
---@param dt number
function CollisionDrawingSystem:process(e, dt)
  love.graphics.push()
  love.graphics.rectangle('line', e.position.x, e.position.y, e.collidable.width, e.collidable.height)
  love.graphics.pop()
end

return CollisionDrawingSystem
