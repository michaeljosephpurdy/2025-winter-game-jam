local EventCleanupSystem = tiny.processingSystem()

---@param e Event | ShortLived
function EventCleanupSystem:filter(e)
  return e.event and not e.time_to_live
end

function EventCleanupSystem:process(e, dt)
  self.world:removeEntity(e)
end

return EventCleanupSystem
