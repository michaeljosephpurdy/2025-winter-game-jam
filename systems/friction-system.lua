local FrictionSystem = tiny.processingSystem()
FrictionSystem.filter = tiny.requireAll('movable', 'velocity')

---@param e Velocity | Movable
function FrictionSystem:process(e, dt) end

return FrictionSystem
