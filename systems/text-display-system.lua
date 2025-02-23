local TextDisplaySystem = tiny.processingSystem()
TextDisplaySystem.filter = tiny.requireAll('position', 'text')

function TextDisplaySystem:initialize(props)
  self.font = love.graphics.newFont('assets/RobotoMono-Regular.ttf', 10, 'mono')
  self.font:setFilter('nearest', 'nearest')

  self.text_color_r = 244 / 255
  self.text_color_g = 244 / 255
  self.text_color_b = 244 / 255
end

---@param e Position | Text
function TextDisplaySystem:process(e, dt)
  local offset_x = self.font:getWidth(e.text) / 2
  local offset_y = self.font:getHeight(e.text) / 2
  local x = e.position.x - offset_x
  local y = e.position.y - offset_y
  love.graphics.push()
  love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b)
  love.graphics.print(e.text, self.font, x, y)
  love.graphics.pop()
end

return TextDisplaySystem
