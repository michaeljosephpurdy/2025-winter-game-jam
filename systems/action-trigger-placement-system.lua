local ActionTriggerPlacementSystem = tiny.system()

---@param props SystemProps
function ActionTriggerPlacementSystem:initialize(props)
  self.mouse_state = props.mouse_state
  self.entity_factory = props.entity_factory
  self.camera_state = props.camera_state
  self.game_state = props.game_state
  self.bump_world = props.bump_world
  self.picked_up_action = nil
end

local action_filter = function(item)
  return item.action
end
local collidable_filter = function(item)
  return item.collidable and not item.action
end

function ActionTriggerPlacementSystem:update(dt)
  if self.game_state.state == 'PLAY' then
    return
  end
  local action_x, action_y = self.camera_state:to_game(self.mouse_state:get_position())
  if not action_x or not action_y then
    return
  end
  local grid_x, grid_y = math.floor(action_x / 16) * 16, math.floor(action_y / 16) * 16
  if self.mouse_state:is_left_click() then
    if self.picked_up_action then
      local new_x, new_y, collisions, collision_count = self.bump_world:move(self.picked_up_action, grid_x, grid_y)
      for i = 1, collision_count do
        local col = collisions[i]
        local oe = col.other
      end
      self.picked_up_action.position:set(new_x, new_y)
    else
      local actions = self.bump_world:queryPoint(action_x, action_y, action_filter)
      self.picked_up_action = actions[1]
    end
  elseif self.mouse_state:is_right_click_just_released() then
    local actions = self.bump_world:queryPoint(action_x, action_y, action_filter)
    local action = actions[1]
    if not action then
      return
    end
    self.game_state:add_action(action.action)
    self.world:remove(action)
  elseif self.mouse_state:is_left_click_just_relased() then
    if self.picked_up_action then
      self.picked_up_action = nil
    else
      local collisions = self.bump_world:queryPoint(action_x, action_y, collidable_filter)
      if #collisions > 0 then
        return
      end
      -- check x and y for valid value
      -- spawn corresponding entity
      local action_type = self.game_state:get_action()
      if not action_type then
        return
      end
      local action = self.entity_factory:build({
        x = grid_x,
        y = grid_y,
        id = 'ACTION',
      })[1]
      action.action = action_type
      if action_type == 'JUMP' then
        action.drawable.sprite = love.graphics.newImage('assets/jump-action.png')
      elseif action_type == 'DRILL' then
        action.drawable.sprite = love.graphics.newImage('assets/drill-action.png')
      elseif action_type == 'WAIT' then
        action.drawable.sprite = love.graphics.newImage('assets/wait-action.png')
      elseif action_type == 'LONG_JUMP' then
        action.drawable.sprite = love.graphics.newImage('assets/long-jump-action.png')
      end
      self.world:addEntity(action)
    end
  end
end

return ActionTriggerPlacementSystem
