local CollisionDetectionSystem = tiny.processingSystem()

---@param props SystemProps
function CollisionDetectionSystem:initialize(props)
  self.bump_world = props.bump_world
  self.game_state = props.game_state
end

---@param oe Entity
local function collision_filter(e, oe)
  if oe.collidable.is_solid then
    return 'slide'
  end
  if oe.action then
    if e.action then
      return 'slide'
    end
    return 'cross'
  end
  if oe.is_level_exit then
    return 'cross'
  end
  return 'cross'
end

---@param e FuturePosition | Position | Collidable | Velocity
function CollisionDetectionSystem:filter(e)
  return e.position and e.collidable and e.collidable.detection and e.future_position and e.velocity
end

---@param e FuturePosition | Position | Collidable | Velocity
function CollisionDetectionSystem:process(e, _)
  if self.game_state.state == 'PAUSE' then
    return
  end
  e.collidable.on_ground = false
  e.collidable.left_wall = false
  e.collidable.right_wall = false
  ---@type (Position | Collidable)[]
  local new_x, new_y, collisions, collision_count =
    self.bump_world:move(e, e.future_position.x, e.future_position.y, collision_filter)
  for i = 1, collision_count do
    local col = collisions[i]
    local oe = col.other
    if col.type == 'touch' then
      e.velocity = vector(0, 0)
    elseif col.type == 'slide' then
      if col.normal.x == 0 then
        e.velocity.y = 0
        if col.normal.y < 0 then
          e.collidable.on_ground = true
          new_y = col.other.position.y - e.collidable.height
        end
      else
        if col.normal.x < 0 then
          e.collidable.right_wall = true
        end
        if col.normal.x > 0 then
          e.collidable.left_wall = true
        end
      end
    elseif col.type == 'cross' then
      if oe.action and not oe.collidable.on_ground then
        goto continue
      end
      ---@cast oe +Action
      if oe.action == 'JUMP' then
        self.world:remove(oe)
        e.velocity.y = -300
      elseif oe.action == 'LONG_JUMP' then
        self.world:remove(oe)
        e.velocity.y = -200
        if e.movable.move_forward then
          e.velocity.x = 800
        elseif e.movable.move_backward then
          e.velocity.x = -800
        end
      elseif oe.action == 'WAIT' then
        e.movable.paused = true
        self.world:remove(oe)
        self.world:add({
          time_to_live = 1,
          fn = function()
            e.movable.paused = false
          end,
        })
      end
      ---@cast e +Player
      ---@cast oe +Killer
      if e.player and oe.kills_player then
        self.world:remove(e)
      end
      ---@cast oe -Killer
      ---@cast e -Player
      ---@cast oe -Action
      ---@cast oe +Trigger
      if e.player and oe.trigger and not oe.trigger.triggered then
        oe.trigger.triggered = true
        ---@cast oe +LinkedLevel
        if oe.linked_level_id then
          ---@type ScreenTransitionEvent
          local event = {
            screen_transition_event = {
              transition_time = 1,
              level_to_load = oe.linked_level_id,
            },
          }
          tiny_world:addEntity(event)
          ---@cast oe -LinkedLevel
        end
      end
      ::continue::
    end
  end
  e.position = vector(new_x, new_y)
end

return CollisionDetectionSystem
