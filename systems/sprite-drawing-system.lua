local SpriteDrawingSystem = tiny.sortedProcessingSystem()
SpriteDrawingSystem.filter = tiny.requireAll('position', 'drawable')

---@param e Position | Drawable
function SpriteDrawingSystem:filter(e)
  return e.position and e.drawable
end

---@param props SystemProps
function SpriteDrawingSystem:initialize(props)
  self.ordered_sprites = {}
  self.default_offset = vector(0, 0)
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
  elseif sprite.drawable.color then
    love.graphics.setColor(sprite.drawable.color.r or 0, sprite.drawable.color.g or 0, sprite.drawable.color.b or 0)
    love.graphics.rectangle('fill', x, y, sprite.drawable.width, sprite.drawable.height)
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
