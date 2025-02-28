local AudioSystem = tiny.processingSystem()
AudioSystem.filter = tiny.requireAll('audio')

---@param props SystemProps
function AudioSystem:initialize(props)
  self.sources = {
    MUSIC = love.audio.newSource('assets/music.wav', 'static'),
    WIN = love.audio.newSource('assets/audio_sfx_2.wav', 'static'),
    BUMP = love.audio.newSource('assets/audio_sfx_1.wav', 'static'),
    JUMP = love.audio.newSource('assets/audio_sfx_0.wav', 'static'),
    LONG_JUMP = love.audio.newSource('assets/audio_sfx_3.wav', 'static'),
    DIE = love.audio.newSource('assets/audio_sfx_4.wav', 'static'),
  }
  self.volume = 0.05
  love.audio.setVolume(self.volume)
  self.keyboard_state = props.keyboard_state
end

function AudioSystem:onAddToWorld()
  ---@type Audio
  local bg_music = { audio = 'MUSIC' }
  self.world:addEntity(bg_music)
end

function AudioSystem:postWrap()
  if self.keyboard_state:is_key_just_released('m') then
    if love.audio.getVolume() > 0 then
      love.audio.setVolume(0)
    else
      love.audio.setVolume(self.volume)
    end
  end
end

---@param e Audio
function AudioSystem:onAdd(e)
  local source = self.sources[e.audio]
  if e.audio == 'MUSIC' then
    source:setLooping(true)
  else
    self.world:removeEntity(e)
  end
  source:play()
end

function AudioSystem:onEntityRemove(e)
  self.world:addEntity(e)
end

return AudioSystem
