local CameraSystem = tiny.processingSystem()

---@param e (CameraActor | Position) | table
function CameraSystem:filter(e)
  return (e.camera_actor and e.position) or e.screen_shake or e.resize
end

---@param props SystemProps
function CameraSystem:initialize(props)
  self.camera_state = props.camera_state
  self.level_info = props.level_information
  self.push = require('plugins.push')
  local windowWidth, windowHeight = love.graphics.getDimensions()
  self.push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
  })
  self.push:resize(windowWidth, windowHeight)
  self.push:setBorderColor(PALETTE.BACKGROUND)
  self.position = vector(0, 0)
  self.offset = vector(-GAME_WIDTH / 2, -GAME_HEIGHT / 2)
  self.speed = 5
  self.screen_info = props.screen_information
  props.push = self.push
  if HOT_RELOAD then
    love.window.setPosition(944, 516)
  end
end

function CameraSystem:preWrap(dt)
  self.push:start()
end

function CameraSystem:postWrap(dt)
  self.push:finish()
end

function CameraSystem:onAdd(e)
  if e.resize and e.is_event then
    self.push:resize(e.width, e.height)
    self.screen_info.width, self.screen_info.height = e.width, e.height
  end
end

---@param e (CameraActor| Position)
function CameraSystem:process(e, dt)
  if e.camera_actor and e.camera_actor.is_active then
    self.old_position = self.position:clone()
    self.position = e.position + self.offset
    if e.position.x >= self.level_info.bottom_right.x - GAME_WIDTH / 2 then
      self.position.x = self.level_info.bottom_right.x - GAME_WIDTH
    elseif e.position.x <= self.level_info.top_left.x + GAME_WIDTH / 2 then
      self.position.x = self.level_info.top_left.x
    end
    -- build y
    self.position.y = self.level_info.bottom_right.y - GAME_HEIGHT
    self.position.x = lerp(self.old_position.x, self.position.x, self.speed * dt)
    self.position.y = lerp(self.old_position.y, self.position.y, self.speed * dt)
    love.graphics.translate(-self.position.x, -self.position.y)
    self.camera_state:persist(-self.position.x, -self.position.y, self.push:getScale())
    self.camera_state:set_screen_rect(
      self.position.x + self.offset.x,
      self.position.y + self.offset.y,
      self.position.x + GAME_WIDTH,
      self.position.y + GAME_HEIGHT
    )
    return
  end
  if e.screen_shake then
    local shake = love.math.newTransform()
    shake:translate(love.math.random(-e.magnitude, e.magnitude), love.math.random(-e.magnitude, e.magnitude))
    love.graphics.applyTransform(shake)
    return
  end
end

return CameraSystem
