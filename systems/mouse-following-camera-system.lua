local MouseFollowingCameraSystem = tiny.system()

---@param props SystemProps
function MouseFollowingCameraSystem:initialize(props)
  self.camera_state = props.camera_state
  self.game_state = props.game_state
  self.level_info = props.level_information
  self.push = props.push
  self.mouse_state = props.mouse_state
  self.position = vector(0, 0)
  self.offset = vector(-GAME_WIDTH / 2, -GAME_HEIGHT / 2)
  self.speed = 4
end

---@param dt number
function MouseFollowingCameraSystem:update(dt) end

function whatever()
  local x, y = self.push:toGame(self.mouse_state:get_position())
  if not x or not y then
    return
  end
  self.old_position = self.position:clone()
  self.position = vector(x, y) + self.offset
  if x >= self.level_info.bottom_right.x - GAME_WIDTH / 2 then
    self.position.x = self.level_info.bottom_right.x - GAME_WIDTH
  elseif x <= self.level_info.top_left.x + GAME_WIDTH / 2 then
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
end

return MouseFollowingCameraSystem
