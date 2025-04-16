--- @type Vector2
local Vector2 = require("Vector2").Vector2


--- @class InputManager
local InputManager = {}
InputManager.__index = InputManager

-- シングルトンインスタンス
--- @class InputManager
local singleton_object = nil

--- コンストラクタ
--- @return InputManager
function InputManager.new()
    -- インスタンスがなければ生成
    if singleton_object == nil then
        --- @class InputManager
        singleton_object = setmetatable({}, InputManager)
        singleton_object:init()
    end
    return singleton_object
end

function InputManager:init()
    --- @type boolean
    self._enabled = true

    --- 現在フレームのキー状態
    --- @type { love.Scancode: boolean }
    self.keysDown = {}
    --- 前フレームのキーの状態
    --- @type { love.Scancode: boolean}
    self.prevKeysDown = {}

    -- マウスボタンの状態
    self.mouseButtons = {}
    -- 前フレームのマウスボタンの状態
    self.prevMouseButtons = {}

    -- マウス座標
    self.mousePosition = Vector2.new()
    -- マウスホイール移動量
    self.wheelDelta = Vector2.new()
end

function InputManager:update()
    if not self._enabled then return end

    for key, value in pairs(self.keysDown) do
        self.prevKeysDown[key] = value
    end

    for button, value in pairs(self.mouseButtons) do
        self.prevMouseButtons[button] = value
    end

    self.wheelDelta:set(0, 0)
end


--- @param active boolean
function InputManager:setActive(active)
    self._enabled = active
end


-- ===キーボード===

--- キーが押されているか(毎フレーム)
--- @param key love.Scancode
--- @return boolean
function InputManager:getKey(key)
    if not self._enabled then return false end
    return self.keysDown[key] or false
end

--- キーが押されているか(1フレーム)
--- @param key love.Scancode
--- @return boolean
function InputManager:getKeyDown(key)
    if not self._enabled then return false end
    return self.keysDown[key] and not self.prevKeysDown[key]
end

--- キーが離されたか
--- @param key love.Scancode
--- @return boolean
function InputManager:getKeyUp(key)
    if not self._enabled then return false end
    return not self.keysDown[key] and self.prevKeysDown[key]
end

--- 複数のキーが同時に押されているか(1フレーム)
--- @deprecated 未実装<常にfalseが返される>
--- @param ... love.Scancode
--- @return boolean
function InputManager:getKeysDown(...)
    -- if not self._enabled then return false end
    -- for _, key in ipairs({...}) do
    --     if not (self.keysDown[key] and not self.prevKeysDown[key]) then
    --         return false
    --     end
    -- end

    return false
end


-- ===マウスボタン===

--- マウスボタンが押されているか(毎フレーム)
--- @param button number
--- @return boolean
function InputManager:getMouseButton(button)
    if not self._enabled then return false end
    return self.mouseButtons[button] or false
end

--- マウスボタンが押されているか(1フレーム)
--- @param button number
--- @return boolean
function InputManager:getMouseButtonDown(button)
    if not self._enabled then return false end
    return self.mouseButtons[button] and not self.prevMouseButtons[button]
end

--- マウスボタンが離されたか
--- @param button number
--- @return boolean
function InputManager:getMouseButtonUp(button)
    if not self._enabled then return false end
    return not self.mouseButtons[button] and self.prevMouseButtons[button]
end


-- ===マウス座標===

--- マウス座標を取得
--- @return Vector2
function InputManager:getMousePos()
    return self.mousePosition
end


--- ===マウスホイール===

--- マウスホイールの移動量を取得
--- @return Vector2
function InputManager:getWheelDelta()
    return self.wheelDelta
end


--- =====コールバック=====

--- キー
--- @private
function InputManager:onKeyPressed(key)
    self.keysDown[key] = true
end
--- @private
function InputManager:onKeyReleased(key)
    self.keysDown[key] = false
end

--- マウス
--- @private
function InputManager:onMousePressed(button)
    self.mouseButtons[button] = true
end
--- @private
function InputManager:onMouseReleased(button)
    self.mouseButtons[button] = false
end
--- @private
function InputManager:onMouseMoved(x, y)
    self.mousePosition:set(x, y)
end
--- @private
function InputManager:onWheelMoved(x, y)
    self.wheelDelta:set(x, y)
end


--- ===love2dにフック===

--- キー
function love.keypressed(key, scancode, isrepeat)
    singleton_object:onKeyPressed(scancode)
end

function love.keyreleased(key, scancode)
    singleton_object:onKeyReleased(scancode)
end

function love.mousepressed(x, y, button)
    singleton_object:onMousePressed(button)
end

function love.mousereleased(x, y, button)
    singleton_object:onMouseReleased(button)
end

function love.mousemoved(x, y)
    singleton_object:onMouseMoved(x, y)
end

function love.wheelmoved(x, y)
    singleton_object:onWheelMoved(x, y)
end

_G.InputManager = InputManager.new()