local CollisionDetectionSystem = tiny.processingSystem()

---@param props SystemProps
function CollisionDetectionSystem:initialize(props)
  self.bump_world = props.bump_world
end

---@param e FuturePosition | Position | Collidable | Velocity
function CollisionDetectionSystem:filter(e)
  return e.position and e.collidable and e.collidable.detection and e.future_position and e.velocity
end

---@param e FuturePosition | Position | Collidable | Velocity
function CollisionDetectionSystem:process(e, _)
  e.collidable.on_ground = false
  e.collidable.left_wall = false
  e.collidable.right_wall = false
  ---@type (Position | Collidable)[]
  local new_x, new_y, collisions, collision_count =
    self.bump_world:move(e, e.future_position.x, e.future_position.y, e.collidable.filter)
  for i = 1, collision_count do
    local col = collisions[i]
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
      ---@cast e +Player
      local oe = col.other
      ---@cast oe +JumpActionEntity
      if oe.action and oe.action == 'JUMP' then
        e.velocity.y = -300
        self.world:remove(oe)
      end
      ---@cast oe -JumpActionEntity
      ---@cast oe +Trigger
      if e.player and oe.trigger and not oe.trigger.triggered then
        oe.trigger.triggered = true
        ---@cast oe -JumpActionEntity
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
    end
  end
  e.position = vector(new_x, new_y)
end

return CollisionDetectionSystem
