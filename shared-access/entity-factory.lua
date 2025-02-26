---@class EntityFactory
local EntityFactory = class('EntityFactory') --[[@as EntityFactory]]
---@enum EntityTypes
local EntityTypes = {
  PLAYER = 'PLAYER',
  PLAYER_SPAWN = 'PLAYER_SPAWN',
  LEVEL_EXIT = 'LEVEL_EXIT',
  ACTION = 'ACTION',
  ONE_EYE = 'ONE_EYE',
  STATIONARY_ACTION = 'STATIONARY_ACTION',
  TEXT = 'TEXT',
}
EntityFactory.types = EntityTypes

---@param type EntityTypes
---@return Entity
function parseEntity(type)
  if type == 'PLAYER_SPAWN' then
    return {
      player_spawn = true,
    }
  elseif type == 'TEXT' then
    ---@type Position | Text
    return {
      position = vector(0, 0),
      text = 'test',
    }
  elseif type == 'ACTION' then
    ---@type ActionEntity
    return {
      position = vector(0, 0),
      gravity = {},
      future_position = vector(0, 0),
      delta_position = vector(0, 0),
      velocity = vector(0, 0),
      drawable = {
        color = { r = 0, g = 0, b = 1 },
        width = 16,
        height = 16,
      },
      collidable = {
        height = 16,
        width = 16,
        detection = true,
      },
    }
  elseif type == 'LEVEL_EXIT' then
    ---@type LevelExitEntity
    return {
      is_level_exit = true,
      drawable = { color = { g = 0.75 }, width = 16, height = 16 },
      collidable = { width = 16, height = 16 },
      trigger = {},
    }
  elseif type == 'ONE_EYE' then
    ---@type Killer | Drawable | Movable | Collidable
    return {
      kills_player = true,
      drawable = {
        width = 16,
        height = 16,
        color = { r = 1, b = 1, g = 0 },
      },
      movable = {
        move_forward = true,
        move_backward = false,
        acceleration = 3,
      },
      collidable = {
        detection = true,
        height = 16,
        width = 16,
      },
      velocity = vector(0, 0),
      delta_position = vector(0, 0),
      future_position = vector(0, 0),
      position = vector(0, 0),
      gravity = {},
    }
  elseif type == 'PLAYER' then
    return {
      camera_actor = { is_active = true },
      controllable = { is_active = true },
      is_character = true,
      drawable = { color = { r = 1, g = 0, b = 0 }, width = 16, height = 16 },
      player = { is_active = true },
      collidable = {
        detection = true,
        radius = 10,
        width = 16,
        height = 16,
      },
      movable = {
        is_moving = false,
        speed = 0,
        max_speed = 850,
        acceleration = 20,
        move_forward = true,
        move_backward = false,
        last_direction = 'forward',
      },
      velocity = vector(0, 0),
      delta_position = vector(0, 0),
      future_position = vector(0, 0),
      position = vector(0, 0),
      gravity = {},
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
    if IS_DEV and not e.customFields.entrance then
      print('no linked_level_id for e.level_id')
    else
      ---@cast entity LevelExitEntity
      entity.linked_level_id = e.customFields.entrance.levelIid
    end
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
