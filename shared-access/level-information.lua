---@class LevelInformation
local LevelInformation = class('LevelInformation') --[[@as LevelInformation]]
LevelInformation.static.is_singleton = true

function LevelInformation:initialize()
  self.top_left = vector(0, 0)
  self.bottom_right = vector(0, 0)
  self.level_id = STARTING_LEVEL_ID
end

return LevelInformation
