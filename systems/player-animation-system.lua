local PlayerAnimationSystem = tiny.processingSystem()
PlayerAnimationSystem.filter = tiny.requireAll('player', 'movable', 'jumpable', 'animation', 'drawable')

---@param e PlayerEntity
function PlayerAnimationSystem:process(e, dt)
  e.animation.current_tag = 'idle'
  if e.movable.is_moving then
    e.animation.current_tag = 'run'
  end
  if e.jumpable.state == 'charging' then
    if e.jumpable.charge_small_jump then
      e.animation.current_tag = 'small-charge'
    elseif e.jumpable.charge_large_jump then
      e.animation.current_tag = 'large-charge'
    end
  elseif e.jumpable.state == 'jumping' then
    if e.jumpable.did_small_jump then
      e.animation.current_tag = 'small-jump'
    elseif e.jumpable.did_large_jump then
      e.animation.current_tag = 'large-jump'
    end
    if e.velocity.y > 0 then
      e.animation.current_tag = 'run'
    end
  end
  if e.movable.last_direction == 'forward' then
    e.drawable.flip = false
  elseif e.movable.last_direction == 'backward' then
    e.drawable.flip = true
  end
end

return PlayerAnimationSystem
