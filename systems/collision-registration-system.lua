local CollisionRegistrationSystem = tiny.processingSystem()

---@param e Collidable | Position
function CollisionRegistrationSystem:filter(e)
  return e.position and e.collidable
end

---@param props SystemProps
function CollisionRegistrationSystem:initialize(props)
  self.bump_world = props.bump_world
end

---@param e Collidable | Position
function CollisionRegistrationSystem:onAdd(e)
  if not e.collidable.width or not e.collidable.height then
    assert(nil, e.type .. ' does not have collision.width or collision.height')
  end
  if self.bump_world:hasItem(e) then
    return
  end
  self.bump_world:add(e, e.position.x, e.position.y, e.collidable.width, e.collidable.height)
end

---@param e Collidable | Position
function CollisionRegistrationSystem:onRemove(e)
  self.bump_world:remove(e)
end

return CollisionRegistrationSystem
