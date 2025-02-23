---@class CameraState
local CameraState = class('CameraState') --[[@as CameraState]]

function CameraState:initialize()
  self.screen_x = 0
  self.screen_y = 0
  self.screen_xx = 0
  self.screen_yy = 0
end

function CameraState:set_screen_rect(x, y, xx, yy)
  self.screen_x = x
  self.screen_y = y
  self.screen_xx = xx
  self.screen_yy = yy
end

function CameraState:get_screen_rect()
  return { x = self.screen_x, y = self.screen_y, xx = self.screen_xx, yy = self.screen_yy }
end

function CameraState:to_game_coord(x, y)
  return (x - self.translation_x) / self.scale_x, (y - self.translation_y) / self.scale_y
end

---@param translation_x number
---@param translation_y number
---@param scale_x number
---@param scale_y number
function CameraState:persist(translation_x, translation_y, scale_x, scale_y)
  self.translation_x, self.translation_y = translation_x, translation_y
  self.scale_x, self.scale_y = scale_x, scale_y
end

return CameraState
