local SpriteDrawingSystem = tiny.sortedProcessingSystem()
SpriteDrawingSystem.filter = tiny.requireAll('position', 'drawable')

function SpriteDrawingSystem:initialize()
  self.ordered_sprites = {}
  self.default_offset = vector(0, 0)
end

---@param e Drawable
function SpriteDrawingSystem:onAdd(e)
  if e.drawable.centered then
    local width, height = e.drawable.sprite:getDimensions()
    e.drawable.sprite_offset = vector(-width / 2, -height / 2)
  end
end

---@param e1 Drawable
---@param e2 Drawable
function SpriteDrawingSystem:compare(e1, e2)
  return (e1.drawable.z_index or 0) < (e2.drawable.z_index or 0)
end

---@param sprite Position | Drawable
function SpriteDrawingSystem:process(sprite, dt)
  if sprite.drawable.hidden then
    return
  end
  love.graphics.push()
  local x, y = sprite.position.x, sprite.position.y
  local position_offset = sprite.drawable.sprite_offset or self.default_offset
  local rotation = sprite.drawable.rotation or 0
  local rotation_offset = sprite.drawable.rotation_offset or self.default_offset
  local x_dir = 1
  local offset_x = position_offset.x
  if sprite.drawable.flip then
    x_dir = x_dir * -1
    offset_x = offset_x * -1
  end
  ---@cast sprite +Shadow
  if sprite.shadow then
    local alpha = sprite.shadow.alpha or 0.5
    local offset = sprite.shadow.offset or vector(0, 10)
    local position = sprite.position + offset
    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.ellipse('fill', position.x, position.y, sprite.shadow.radius.x, sprite.shadow.radius.y)
    love.graphics.setColor(1, 1, 1, 1)
  end
  ---@cast sprite -Shadow
  if sprite.drawable.animation then
    sprite.drawable.animation:draw(
      x + offset_x,
      y + position_offset.y,
      rotation,
      x_dir,
      1,
      rotation_offset.x,
      rotation_offset.y
    )
  else
    love.graphics.draw(
      sprite.drawable.sprite,
      x + offset_x,
      y + position_offset.y,
      rotation,
      x_dir,
      1,
      rotation_offset.x,
      rotation_offset.y
    )
  end
  love.graphics.pop()
end

return SpriteDrawingSystem
