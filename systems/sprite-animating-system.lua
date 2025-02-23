local SpriteAnimatingSystem = tiny.processingSystem()
SpriteAnimatingSystem.filter = tiny.requireAll('drawable', 'animation')

---@param e Animation | Drawable
function SpriteAnimatingSystem:onAdd(e)
  e.animation.animation = peachy.new(e.animation.data, e.animation.image)
  e.drawable.animation = e.animation.animation
end

---@param e Animation | Drawable
---@param dt number
function SpriteAnimatingSystem:process(e, dt)
  e.animation.animation:setTag(e.animation.current_tag)
  e.animation.animation:play()
  e.animation.animation:update(dt)
end

return SpriteAnimatingSystem
