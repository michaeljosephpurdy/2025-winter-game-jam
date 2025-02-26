local TileMapSystem = tiny.processingSystem()

---@param e Event
function TileMapSystem:filter(e)
  return e.event and e.event.load_tile_map
end

---@type number[]
local SOLID_TILES = { 1, 3 }

---@param props SystemProps
function TileMapSystem:initialize(props)
  self.level_information = props.level_information
  self.game_state = props.game_state
  self.ldtk = require('plugins.super-simple-ldtk')
  self.ldtk:init('world')
  self.ldtk:load_all()
  self.entity_factory = props.entity_factory
  self.on_image = function(image)
    ---@type Position | Drawable
    local image_data = {
      position = vector(image.x, image.y),
      drawable = { sprite = love.graphics.newImage(image.image), z_index = -1 },
    }
    self.world:add(image_data)
  end
  self.on_tile = function(tile)
    for _, solid in ipairs(SOLID_TILES) do
      if tile.value == solid then
        ---@type TileEntity
        local solid_tile = {
          position = vector(tile.x, tile.y),
          collidable = { is_tile = true, is_solid = true, width = 16, height = 16 },
        }
        self.world:add(solid_tile)
      end
    end
  end
  self.on_entity = function(e)
    local entities = self.entity_factory:build(e)
    for _, entity in pairs(entities) do
      self.world:add(entity)
    end
  end
end

function TileMapSystem:onAdd(e)
  local level_id = e.level_id or self.loaded_level or 'Level_0'
  local loaded_level = self.ldtk:load(level_id, self.on_image, self.on_tile, self.on_entity)
  self.game_state:set_actions(loaded_level.available_actions)
  self.level_information.top_left = vector(loaded_level.x, loaded_level.y)
  self.level_information.bottom_right = vector(loaded_level.xx, loaded_level.yy)
  self.level_information.level_id = loaded_level.level_id
  self.loaded_level = level_id
  self.game_state.state = 'PAUSE'
end

return TileMapSystem
