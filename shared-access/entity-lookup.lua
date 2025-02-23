---@class EntityLookup
local EntityLookup = class('EntityLookup')

function EntityLookup:initialize()
  ---@private
  ---@type PlayerEntity
  self.player = nil
end

function EntityLookup:get_player()
  return self.player
end

---@param e Entity
function EntityLookup:add(e)
  if e.player then
    self.player = e --[[@as PlayerEntity]]
  end
end

---@param e Entity
function EntityLookup:remove(e)
  if e.player then
    self.player = nil
  end
end

return EntityLookup --[[@as EntityLookup]]
