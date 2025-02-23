local CollisionUpdateSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('is_solid', 'is_tile')
CollisionUpdateSystem.filter = tiny.requireAll('future_position', 'position', rejection_filter)

---@param e FuturePosition | Position
function CollisionUpdateSystem:process(e, dt)
  e.position = e.future_position:clone()
end

return CollisionUpdateSystem
