local Engine_env = require("DeluataEngine_env")
local Component = require("abstruct.Component").Component
local Object = require("abstruct.Object").Object
local Transform = require("Transform").Transform
local SceneManager = require("SceneManager").SceneManager
local Vector2 = require("Vector2").Vector2

-- SceneManagerインスタンス
local sceneManagerInstance = SceneManager.new()

--- ゲームオブジェクトを司るクラス
--- @class GameObject:Object
--- 継承
--- @field super Object
--- @field _enabled boolean
--- GameObjectメンバ
--- @field name string
--- @field transform Transform
--- @field scene Scene
--- @field components Component[]
local GameObject = Object:extend()
GameObject.__index = GameObject

--- GameObjectコンストラクタ
--- @param name? string
--- @param pos? Vector2
--- @param rotation? number
--- @param scale? Vector2
--- @return GameObject
function GameObject.new(name, pos, rotation, scale)
    --- @class GameObject
    local instance = setmetatable({}, GameObject)
    instance:init(
        name,
        Transform.new(
            instance,
            pos or Vector2.new(),
            rotation or 0,
            scale or Vector2.new(1, 1)
        )
    )
    return instance
end

--- 初期化処理
--- @protected
--- @param name string|nil
--- @param transform Transform
function GameObject:init(name, transform)
    -- スーパークラスの初期化
    self.super:init()

    --- @private
    --- @type string
    self.name = name or "AnonymousGameObject"

    --- @private
    --- @type Transform
    self.transform = transform

    --- @private
    --- @type Scene
    self.scene = sceneManagerInstance:getCurrentScene()

    --- @private
    --- @type Component[]
    self.components = {}

    if self.scene then
        self.scene:addGameObject(self)
    end
end


-- ========== metamethod ==========

--- @private
--- @return string
function GameObject:__tostring()
    return "GameObject: "..self.name
end


-- ========== DeLuataEngine ==========

--- オブジェクトの初期化
function GameObject:load()
    for _, component in ipairs(self.components) do
        if component:isEnable() then
            component:load()
        end
    end
end

--- オブジェクトの更新処理
--- @param dt number
function GameObject:update(dt)
    if self._enabled then
        for _, component in ipairs(self.components) do
            -- 有効なComponentのみ更新
            if component:isEnable() then
                component:update(dt)
            end
        end
    end
end

--- Gameobjectを破棄する
function GameObject:destroy()
    for i, obj in ipairs(self.scene.gameObjects) do
        if obj == self then
            table.remove(self.scene.gameObjects, i)
            break
        end
    end
    -- Componentの削除
    for _, component in ipairs(self.components) do
        self:removeComponent(component.__index)
    end
    -- Transformの削除
    self.transform:destroy()
    --- コールバック関数を呼び出す
    self:onDestroy()

    -- メモリリーク防止
    self.super = nil
    self.transform = nil
    self.scene = nil
    self.components = nil
end

--- オブジェクトの有効化無効化
--- @param active boolean
function GameObject:setActive(active)
    -- 状態がすでに_enabledと同じときスルー
    if self._enabled == active then return end

    -- _enabledを切り替えてコールバック関数を呼び出す
    self._enabled = active
    if self._enabled then
        --- Component有効化
        for _, component in ipairs(self.components) do
            component:setActive(true)
        end
        self:onEnable()
    else
        --- Componentの無効化
        for _, component in ipairs(self.components) do
            component:setActive(false)
        end
        self:onDisable()
    end
end

--- Componentを追加する
--- @param componentType Component
function GameObject:addComponent(componentType, ...)
    -- Component以外をアタッチ仕様とした場合のエラー
    --if not componentType:is(Component) then
    if componentType.__index ~= Component then
        error("The argument type is wrong! addComponent only takes an object of type Component as an argument!")
    end
    -- Transformをアタッチしようとした場合のエラー処理
    if componentType.__index == Transform then
        error("Transform already exists on this GameObject")
    end
    -- Componentの重複チェック
    for _, existingComponent in ipairs(self.components) do
        if existingComponent.__index == componentType.__index then
            error("Component of type " .. tostring(componentType.__index) .. " already exists on this GameObject.")
        end
    end
    -- Componentをインスタンス化
    local componentInstance = componentType.new(self, ...)
    table.insert(self.components, componentInstance)
end

--- Componentを削除する
--- @param componentType Component
function GameObject:removeComponent(componentType)
   for i, component in ipairs(self.components) do
        if component.__index == componentType then
            table.remove(self.components, i)
            component:destroy()
            break
        end
   end
end

--- 指定したComponentを取得する
--- @param componentType Component
--- @return Component|nil
function GameObject:getComponent(componentType)
    for _, component in ipairs(self.components) do
        if component.__index == componentType then
            return component
        end
    end
    --error("Component not found: "..tostring(componentType))
    return nil
end

-- ==========CallBacks==========

--- オブジェクトの有効化コールバック関数
function GameObject:onEnable()
end

--- オブジェクトの無効化コールバック関数
function GameObject:onDisable()
end

--- オブジェクトの破棄コールバック関数
function GameObject:onDestroy()
end


return{
    GameObject=GameObject
}