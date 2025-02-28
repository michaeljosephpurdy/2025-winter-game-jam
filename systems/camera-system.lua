local CameraSystem = tiny.processingSystem()

---@param e Event
function CameraSystem:filter(e)
  return e.event and e.event.screen_resize
end

---@param props SystemProps
function CameraSystem:initialize(props)
  self.is_draw_system = true
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
    if not x or not y then
      return nil, nil
    end
    local _x, _y = self.push:toGame(x, y)
    if not _x or not _y then
      return nil, nil
    end
    return _x + self.position.x, _y + self.position.y
  end
  props.camera_state.to_real = function(camera_self, x, y)
    return self.push:toReal(x - self.position.x, y - self.position.y)
  end
end

---@param dt number
function CameraSystem:preWrap(dt)
  self.push:start()
  self.position = self.level_info.top_left:clone()
  love.graphics.translate(-self.level_info.top_left.x, -self.level_info.top_left.y)
end

---@param dt number
function CameraSystem:postWrap(dt)
  self.push:finish()
end

---@param e Event
function CameraSystem:onAdd(e)
  local event = e.event
  if not event or not event.screen_resize then
    return
  end
  self.push:resize(event.width, event.height)
  self.screen_info.width, self.screen_info.height = event.width, event.height
end

---@param e (CameraActor| Position)
function CameraSystem:process(e, dt)
  return
end

return CameraSystem
