local AudioSystem = tiny.processingSystem()
AudioSystem.filter = tiny.requireAll('audio')

function AudioSystem:initialize()
  self.sources = {
    MUSIC = love.audio.newSource('assets/music.wav', 'static'),
    WIN = love.audio.newSource('assets/audio_sfx_2.wav', 'static'),
    BUMP = love.audio.newSource('assets/audio_sfx_1.wav', 'static'),
    JUMP = love.audio.newSource('assets/audio_sfx_0.wav', 'static'),
    LONG_JUMP = love.audio.newSource('assets/audio_sfx_3.wav', 'static'),
    DIE = love.audio.newSource('assets/audio_sfx_4.wav', 'static'),
  }
  love.audio.setVolume(0.05)
end

function AudioSystem:onAddToWorld()
  ---@type Audio
  local bg_music = { audio = 'MUSIC' }
  self.world:addEntity(bg_music)
end

---@param e Audio
function AudioSystem:onAdd(e)
  local source = self.sources[e.audio]
  source:play()
  if e.audio ~= 'MUSIC' then
    self.world:removeEntity(e)
  end
end

function AudioSystem:onEntityRemove(e)
  self.world:addEntity(e)
end

return AudioSystem
