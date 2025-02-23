---@class EntityFactory
local EntityFactory = class('EntityFactory') --[[@as EntityFactory]]
---@enum EntityTypes
local EntityTypes = {
  PLAYER = 'PLAYER',
  PLAYER_SPAWN = 'PLAYER_SPAWN',
  LEVEL_EXIT = 'LEVEL_EXIT',
  JUMP_ACTION = 'JUMP_ACTION',
  WAIT_ACTION = 'WAIT_ACTION',
  DRILL_ACTION = 'DRILL_ACTION',
  LONG_JUMP_ACTION = 'LONG_JUMP_ACTION',
}
EntityFactory.types = EntityTypes

---@param type EntityTypes
---@return Entity
function parseEntity(type)
  if type == 'PLAYER_SPAWN' then
    return {
      player_spawn = true,
    }
  elseif type == 'JUMP_ACTION' then
    ---@type JumpActionEntity
    return {
      position = vector(0, 0),
      action = 'JUMP',
      gravity = { enabled = true },
      velocity = vector(0, 0),
      collidable = {
        height = 16,
        width = 16,
      },
    }
  elseif type == 'LEVEL_EXIT' then
    ---@type LevelExitEntity
    return {
      is_level_exit = true,
      drawable = { sprite = love.graphics.newImage('assets/exit.png') },
      collidable = { radius = 16, width = 32, height = 32 },
      trigger = {},
    }
  elseif type == 'PLAYER' then
    return {
      camera_actor = { is_active = true },
      controllable = { is_active = true },
      is_character = true,
      --drawable = {
      --sprite_offset = vector(-24, 0),
      --},
      --animation = {
      --data = 'assets/dog.json',
      --image = love.graphics.newImage('assets/dog.png'),
      --tags = { 'idle', 'run' },
      --current_tag = 'run',
      --animation = nil,
      --},
      player = { is_active = true },
      collidable = {
        detection = true,
        radius = 10,
        width = 24,
        height = 46,
        filter = function(self, other)
          if other.collidable.is_solid then
            return 'slide'
          end
          return 'cross'
        end,
      },
      movable = {
        is_moving = false,
        speed = 0,
        max_speed = 85,
        acceleration = 2,
        move_forward = true,
        move_backward = false,
        last_direction = 'forward',
      },
      jumpable = {
        state = 'jumping',
        can_jump = true,
        small_jump_height = 225,
        large_jump_height = 300,
      },
      velocity = vector(0, 0),
      delta_position = vector(0, 0),
      future_position = vector(0, 0),
      position = vector(0, 0),
      gravity = { enabled = true, on_ground = false },
    }
  end
end

---@param e { customFields?: table, id: string | EntityTypes, type?: string, x: number, y: number }
---@return Entity[]
function EntityFactory:build(e)
  -- We're gonna do some weird overwriting of entity type here
  -- this is because during jam there was singular Entity object
  -- with inner entity type field
  -- Post-jam version though has different Entity object, which is
  -- helpful in LDtk because then fields (like 'path') can be on
  -- some entities and not all
  local entity = self:build_single({
    position = vector(e.x or 0, e.y or 0),
    type = e.id --[[@as EntityTypes]],
  })
  for k, v in pairs(e.customFields or {}) do
    entity[k] = v
  end
  if entity.is_level_exit then
    ---@cast entity LevelExitEntity
    entity.linked_level_id = e.customFields.entrance.levelIid
  end
  return { entity }
end

---@private
---@param e { type: EntityTypes }
---@return Entity
function EntityFactory:build_single(e)
  if not parseEntity(e.type) then
    print('NO ENTITY FOUND FOR TYPE: ' .. (e.type or 'UNKNOWN'))
    return {}
  end
  local new_entity = parseEntity(e.type)
  local position_offset = new_entity.position or vector(0, 0)
  for k, v in pairs(e) do
    new_entity[k] = v
  end
  new_entity.position = new_entity.position + position_offset
  new_entity.type = e.type
  new_entity.draw_debug = true
  return new_entity
end

return EntityFactory
