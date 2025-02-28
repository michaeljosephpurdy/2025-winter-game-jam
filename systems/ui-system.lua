local UISystem = tiny.system()

---@param props SystemProps
function UISystem:initialize(props)
  self.normal_font = love.graphics.newFont('assets/RobotoMono-Regular.ttf', 12, 'mono')
  self.normal_font:setFilter('nearest', 'nearest')
  self.bold_font = love.graphics.newFont('assets/RobotoMono-Bold.ttf', 12, 'mono')
  self.bold_font:setFilter('nearest', 'nearest')
  self.large_font = love.graphics.newFont('assets/RobotoMono-Bold.ttf', 24, 'mono')
  self.large_font:setFilter('nearest', 'nearest')

  self.text_color_r = 244 / 255
  self.text_color_g = 244 / 255
  self.text_color_b = 244 / 255
  self.game_state = props.game_state
end

---@param dt number
function UISystem:update(dt)
  love.graphics.push()
  love.graphics.origin()
  love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b)
  love.graphics.print('ACTIONS', self.bold_font, 0, 0)
  for i, action in ipairs(self.game_state.actions) do
    local y = i * 24
    if i == self.game_state.current_action_index then
      love.graphics.print('*' .. action, self.bold_font, 0, y)
    else
      love.graphics.print(action, self.normal_font, 0, y)
    end
  end
  if self.game_state.state == 'PAUSE' then
    love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b, 0.5)
    love.graphics.print('PAUSE', self.large_font, GAME_WIDTH / 2.4, GAME_HEIGHT / 4)
  end
  if self.game_state.restart_timer > 0 then
    love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b, 1)
    love.graphics.arc('fill', GAME_WIDTH / 2, GAME_HEIGHT / 2, 10, 0, 6.283185 * self.game_state.restart_timer)
  end
  love.graphics.pop()
end

return UISystem
