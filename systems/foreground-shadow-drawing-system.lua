local ForegroundShadowDrawingSystem = tiny.processingSystem()
ForegroundShadowDrawingSystem.filter = tiny.requireAll('position', 'shadow', 'nevermind')

---@param e Position | Shadow
function ForegroundShadowDrawingSystem:process(e, dt)
  local alpha = e.shadow.alpha or 0.5
  local offset = e.shadow.offset or vector(0, 10)
  local position = e.position + offset
  love.graphics.push()
  love.graphics.setColor(0, 0, 0, alpha)
  love.graphics.ellipse('fill', position.x, position.y, e.shadow.radius.x, e.shadow.radius.y)
  love.graphics.pop()
end

return ForegroundShadowDrawingSystem
