local EntityLookupSystem = tiny.processingSystem()
function EntityLookupSystem:filter(e)
  return true
end

---@param props SystemProps
function EntityLookupSystem:initialize(props)
  self.entity_lookup = props.entity_lookup
end

function EntityLookupSystem:onAdd(e)
  self.entity_lookup:add(e)
end

function EntityLookupSystem:onRemove(e)
  self.entity_lookup:remove(e)
end

return EntityLookupSystem
