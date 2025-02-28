local PlayerSpawningSystem = tiny.processingSystem()
PlayerSpawningSystem.filter = tiny.requireAll('player_spawn', 'position')

---@param props SystemProps
function PlayerSpawningSystem:initialize(props)
  self.entity_factory = props.entity_factory
end

---@param e PlayerSpawn | Position
function PlayerSpawningSystem:onAdd(e)
  if not self.player then
    self.player = self.entity_factory:build({
      id = 'PLAYER',
    })[1]
  end
  if e.move_right then
    self.player.movable.move_forward = true
    self.player.movable.move_backward = false
  else
    self.player.movable.move_forward = false
    self.player.movable.move_backward = true
  end
  self.player.position = e.position:clone()
  self.player.velocity = vector(0, 0)
  self.world:addEntity(self.player)
end

return PlayerSpawningSystem
