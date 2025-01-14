local Vector2 = require("Vector2").Vector2
--- @class Input
local Input = {}
Input.__index = Input

-- シングルトンインスタンス
local inputInstance = nil

--- コンストラクタ
--- @return Input
function Input.new()
    -- インスタンスがなければ生成
    if inputInstance == nil then
        --- @class Input
        local instance = setmetatable({
            keysPressed = {},     -- 押されたキー
            keysHeld = {},       -- 押し続けているキー
            keysReleased = {},   -- 離されたキー
            mouseButtonsPressed = {}, -- 押されたマウスボタン
            mouseButtonsHeld = {},   -- 押し続けているマウスボタン
            mouseButtonsReleased = {}, -- 離されたマウスボタン
            mouseX = 0,
            mouseY = 0
        }, Input)

        -- love2dコールバック関数
        function love.keypressed(key)
            instance.keysPressed[key] = true
            instance.keysHeld[key] = true
        end

        function love.keyreleased(key)
            instance.keysReleased[key] = true
            instance.keysHeld[key] = false
        end

        function love.mousepressed(x, y, button)
            instance.mouseButtonsPressed[button] = true
            instance.mouseButtonsHeld[button] = true
            instance.mouseX = x
            instance.mouseY = y
        end

        function love.mousereleased(x, y, button)
            instance.mouseButtonsReleased[button] = true
            instance.mouseButtonsHeld[button] = false
            instance.mouseX = x
            instance.mouseY = y
        end

        function love.mousemoved(x, y, dx, dy, istouch)
            instance.mouseX = x
            instance.mouseY = y
        end
        inputInstance = instance
    end

    return inputInstance
end

----------キーボード----------
--- キーが押されたフレームでのみtrueを返す
--- @param key string キーの名前
--- @return boolean
function Input:isKeyDown(key)
    return self.keysPressed[key] or false
end

--- キーが押されている間trueを返す
--- @param key string キーの名前
--- @return boolean
function Input:isKey(key)
    return self.keysHeld[key] or false
end

--- キーが離されたフレームでのみtrueを返す
--- @param key string キーの名前
--- @return boolean
function Input:isKeyUp(key)
    return self.keysReleased[key] or false
end

--- 毎フレームキー入力状態を更新する
function Input:update()
    self.keysPressed = {}
    self.keysReleased = {}
    self.mouseButtonsPressed = {}
    self.mouseButtonsReleased = {}
end

----------マウス----------
--- マウスボタンが押されたフレームでのみtrueを返す
--- @param button integer マウスボタンの番号
--- @return boolean
function Input:isMouseDown(button)
    return self.mouseButtonsPressed[button] or false
end

--- マウスボタンが押されている間trueを返す
--- @param button integer マウスボタンの番号
--- @return boolean
function Input:isMouseButton(button)
    return self.mouseButtonsHeld[button] or false
end

--- マウスボタンが離されたフレームでのみtrueを返す
--- @param button integer マウスボタンの番号
--- @return boolean
function Input:isMouseUp(button)
    return self.mouseButtonsReleased[button] or false
end

--- マウスのX座標を取得する
--- @return number
function Input:getMouseX()
    return self.mouseX
end

--- マウスのY座標を取得する
--- @return number
function Input:getMouseY()
    return self.mouseY
end

--- マウスの位置を取得する
--- @return Vector2
function Input:getMousePosition()
    return Vector2.new(self.mouseX, self.mouseY)
end

return {
    Input = Input
}