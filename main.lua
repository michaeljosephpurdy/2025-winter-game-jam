function love.load(args)
  IS_DEV = args[1] == '--hotreload'
  STARTING_LEVEL_ID = 'Level_0'
  SIXTY_FPS = 1 / 60
  math.randomseed(os.time())

  json = require('plugins.json')
  tiny = require('plugins.tiny-ecs')
  class = require('plugins.middleclass')
  ldtk = require('plugins.super-simple-ldtk')
  vector = require('plugins.vector')
  cron = require('plugins.cron')
  peachy = require('plugins.peachy')
  bump = require('plugins.bump')
  push = require('plugins.push')

  GAME_WIDTH = 400
  GAME_HEIGHT = 240

  SYSTEMS_IN_ORDER = {
    'systems.entity-lookup-system',
    'systems.player-spawning-system',
    'systems.mouse-state-system',
    'systems.audio-system',
    'systems.keyboard-state-system',
    'systems.game-state-toggle-system',
    'systems.action-choice-system',
    'systems.action-trigger-placement-system',
    'systems.collision-registration-system',
    'systems.tile-map-system',
    'systems.entity-turning-system',
    'systems.movable-to-delta-position-system',
    'systems.movable-to-velocity-system',
    'systems.gravity-application-system',
    'systems.entity-movement-system',
    'systems.sprite-animating-system',
    'systems.coroutine-resuming-system',
    'systems.collision-detection-system',
    'systems.player-level-boundary-system',
    'systems.entity-level-boundary-system',
    'systems.player-animation-system',
    'systems.trigger-resetting-system',
    'systems.camera-system',
    'systems.sprite-drawing-system',
    --'systems.collision-drawing-system',
    'systems.dialogue-system',
    'systems.screen-transition-system',
    'systems.text-display-system',
    'systems.ui-system',
    'systems.entity-cleanup-system',
    'systems.time-to-live-system',
    'systems.delayed-function-execution-system',
    'systems.player-debug-system',
  }

  PALETTE = {
    BACKGROUND = { love.math.colorFromBytes(39, 186, 219) },
  }

  local windowWidth, windowHeight = love.window.getDesktopDimensions()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  logger = require('logger')()

  love.graphics.setLineStyle('rough')
  love.window.setMode(GAME_WIDTH, GAME_HEIGHT)

  tiny_world = tiny.world()
  local bump_world = bump.newWorld(64)

  reload_system_props = function()
    local entity_factory = unrequire_require('shared-access.entity-factory')() --[[@as EntityFactory]]
    local game_state = unrequire_require('shared-access.game-state')() --[[@as GameState]]
    local camera_state = unrequire_require('shared-access.camera-state')() --[[@as CameraState]]
    local mouse_state = unrequire_require('shared-access.mouse')() --[[@as MouseState]]
    local level_information = unrequire_require('shared-access.level-information')() --[[@as LevelInformation]]
    local entity_lookup = unrequire_require('shared-access.entity-lookup')() --[[@as EntityLookup]]
    local keyboard_state = unrequire_require('shared-access.keyboard')() --[[@as KeyboardState]]
    ---@class SystemProps
    system_props = {
      mouse_state = mouse_state,
      entity_factory = entity_factory,
      game_state = game_state,
      camera_state = camera_state,
      level_information = level_information,
      screen_information = { width = GAME_WIDTH, height = GAME_HEIGHT },
      entity_lookup = entity_lookup,
      keyboard_state = keyboard_state,
      bump_world = bump_world,
      push = push,
    }
  end

  reload_world = function()
    reload_system_props()
    local entities = tiny.entities
    print('old system count: ' .. tiny_world:getSystemCount())
    print('old entity count: ' .. tiny_world:getEntityCount())
    tiny_world:clearSystems()
    tiny_world:clearEntities()
    for i, system_name in ipairs(SYSTEMS_IN_ORDER) do
      local system = unrequire_require(system_name)
      assert(system, tostring(i) .. ' # system not found')
      if system.initialize then
        system:initialize(system_props)
      end
      tiny_world:addSystem(system)
    end
    print('new system count: ' .. tiny_world:getSystemCount())
    print('new entity count: ' .. tiny_world:getEntityCount())
    tiny_world:add(entities)
  end

  function start_game()
    print('starting game')
    tiny_world:clearEntities()
    reload_world()
    tiny_world:addEntity({
      event = {
        load_tile_map = true,
      },
    })
    tiny_world:addEntity({
      screen_transition_event = {
        transition_time = 1.5,
        fade_in = true,
      },
    }--[[@as ScreenTransitionEvent]])
  end
  start_game()

  systems_last_modified = love.filesystem.getInfo('systems', 'directory').modtime
  shared_access_last_modified = love.filesystem.getInfo('shared-access', 'directory').modtime
  accumulator = 0
end

function love.update(dt)
  delta_time = dt
  if
    IS_DEV
    and (
      systems_last_modified ~= love.filesystem.getInfo('systems', 'directory').modtime
      or shared_access_last_modified ~= love.filesystem.getInfo('shared-access', 'directory').modtime
    )
  then
    reload_world()
    systems_last_modified = love.filesystem.getInfo('systems', 'directory').modtime
    shared_access_last_modified = love.filesystem.getInfo('shared-access', 'directory').modtime
    return
  end
end

function love.draw()
  accumulator = accumulator + delta_time
  while accumulator >= SIXTY_FPS do
    tiny_world:update(SIXTY_FPS)
    accumulator = accumulator - SIXTY_FPS
  end
end

function love.keypressed(k)
  ---@type Event
  local event = {
    event = {
      key_press = true,
      keycode = k,
    },
  }
  tiny_world:addEntity(event)
end

function love.keyreleased(k)
  ---@type Event
  local event = {
    event = {
      key_release = true,
      keycode = k,
    },
  }
  tiny_world:addEntity(event)
end

function love.resize(w, h)
  ---@type Event
  local event = {
    event = {
      screen_resize = true,
      width = w,
      height = h,
    },
  }
  tiny_world:addEntity(event)
end

function PRINT_TABLE(tbl, depth)
  depth = depth or 0
  local tab = string.rep(' ', depth)
  for k, v in pairs(tbl) do
    print(tab .. k)
    if type(v) == 'table' then
      PRINT_TABLE(v, depth + 1)
    else
      print(tab .. tostring(v))
    end
  end
end

---@param tbl table
---@param item any
function table.delete(tbl, item)
  local index = nil
  for i, v in ipairs(tbl) do
    if v == item then
      index = i
    end
  end
  if index then
    table.remove(tbl, index)
  end
end

---@param min number The minimum value.
---@param val number The value to clamp.
---@param max number The maximum value.
function math.clamp(min, val, max)
  return math.max(min, math.min(val, max))
end

---@param a number|Vector.lua old
---@param b number|Vector.lua target
---@param t number time
function lerp(a, b, t)
  return a + (b - a) * t
end

---@param vec_1 Vector.lua
---@param vec_2 Vector.lua
function overlapping(vec_1, vec_2)
  local dist_square = ((vec_2.x - vec_1.x) * (vec_2.x - vec_1.x)) + ((vec_2.y - vec_1.y) * (vec_2.y - vec_1.y))
  return dist_square < 256
end
-- Removes all references to a module.
-- Do not call unrequire on a shared library based module unless you are 100% confidant that nothing uses the module anymore.
--- @param m string name of the module you want removed.
--- @return boolean true if all references were removed, false otherwise.
--- @return boolean false then this is an error message describing why the references weren't removed.
local function unrequire(m)
  package.loaded[m] = nil
  _G[m] = nil

  -- Search for the shared library handle in the registry and erase it
  local registry = debug.getregistry()
  local nMatches, mKey, mt = 0, nil, registry['_LOADLIB']

  for key, ud in pairs(registry) do
    if
      type(key) == 'string'
      and string.find(key, 'LOADLIB: .*' .. m)
      and type(ud) == 'userdata'
      and getmetatable(ud) == mt
    then
      nMatches = nMatches + 1
      if nMatches > 1 then
        return false, "More than one possible key for module '" .. m .. "'. Can't decide which one to erase."
      end

      mKey = key
    end
  end

  if mKey then
    registry[mKey] = nil
  end

  return true
end

---@param module_path string
---@return unknown
---@return unknown loaderdata
function unrequire_require(module_path)
  unrequire(module_path)
  return require(module_path)
end
