local EntityFollowingCameraSystem = tiny.processingSystem()

---@param e (CameraActor | Position) | Event
function EntityFollowingCameraSystem:filter(e)
  --return nil
  return (e.camera_actor and e.position) or (e.event and e.event.screen_resize)
end

---@param props SystemProps
function EntityFollowingCameraSystem:initialize(props)
  self.camera_state = props.camera_state
  self.level_info = props.level_information
  self.push = props.push
  self.game_state = props.game_state
  self.mouse_state = props.mouse_state
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
  if IS_DEV then
    love.window.setPosition(944, 516)
  end
  props.camera_state.to_game = function(camera_self, x, y)
    local _x, _y = self.push:toGame(x, y)
    return _x + self.position.x, _y + self.position.y
  end
  props.camera_state.to_real = function(camera_self, x, y)
    return self.push:toReal(x - self.position.x, y - self.position.y)
  end
end

---@param dt number
function EntityFollowingCameraSystem:preWrap(dt)
  self.push:start()
end

---@param dt number
function EntityFollowingCameraSystem:postWrap(dt)
  self.push:finish()
end

---@param e Event
function EntityFollowingCameraSystem:onAdd(e)
  local event = e.event
  if not event or not event.screen_resize then
    return
  end
  self.push:resize(event.width, event.height)
  self.screen_info.width, self.screen_info.height = event.width, event.height
end

---@param e (CameraActor| Position)
function EntityFollowingCameraSystem:process(e, dt)
  if e.screen_shake then
    local shake = love.math.newTransform()
    shake:translate(love.math.random(-e.magnitude, e.magnitude), love.math.random(-e.magnitude, e.magnitude))
    love.graphics.applyTransform(shake)
    return
  end
  if not e.camera_actor then
    return
  end
  local x, y = e.position:unpack()
  local speed = self.speed
  if self.game_state.state == 'PAUSE' then
    x, y = self.push:toGame(self.mouse_state:get_position())
    if not x or not y then
      return
    end
    speed = 1
  end
  self.old_position = self.position:clone()
  self.position = vector(x, y) + self.offset
  if x >= self.level_info.bottom_right.x - GAME_WIDTH / 2 then
    self.position.x = self.level_info.bottom_right.x - GAME_WIDTH
  elseif x <= self.level_info.top_left.x + GAME_WIDTH / 2 then
    self.position.x = self.level_info.top_left.x
  end
  if y >= self.level_info.bottom_right.y - GAME_HEIGHT / 2 then
    self.position.y = self.level_info.bottom_right.y - GAME_HEIGHT
  elseif y <= self.level_info.top_left.y + GAME_HEIGHT / 2 then
    self.position.y = self.level_info.top_left.y
  end
  self.position.x = lerp(self.old_position.x, self.position.x, speed * dt)
  self.position.y = lerp(self.old_position.y, self.position.y, speed * dt)
  love.graphics.translate(-self.position.x, -self.position.y)
  self.camera_state:persist(-self.position.x, -self.position.y, self.push:getScale())
  self.camera_state:set_screen_rect(
    self.position.x + self.offset.x,
    self.position.y + self.offset.y,
    self.position.x + GAME_WIDTH,
    self.position.y + GAME_HEIGHT
  )
end

return EntityFollowingCameraSystem
