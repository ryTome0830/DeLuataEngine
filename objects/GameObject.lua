local Object = require("abstruct.Object").Object
local Vector2 = require("Vector2").Vector2
local Transform = require("Transform").Transform

--- すべてのGameObjectを保存する
--- @type GameObject[]
local gameobjects = {}

--- ゲームオブジェクトを登録
--- ゲームオブジェクトを名前で取得
--- すべてのゲームオブジェクトを取得
--- ゲームオブジェクトを削除

--- ゲームオブジェクトを司るクラス
--- @class GameObject:Object
--- 継承
--- @field super Object
--- @field _enabled boolean
--- @field object Object
--- GameObjectメンバ
--- @
local GameObject = Object:extend()
GameObject.__index = GameObject

--- GameObjectコンストラクタ
--- @private
--- @param name string
--- @param pos Vector2
--- @param rotation number
--- @param scale Vector2
--- @return GameObject
function GameObject.new(name, pos, rotation, scale)
    -- エラー処理
    if #gameobjects >= GAMEOBJECT_MAX_NUM then
        error("The maximum number of GameObjects has been reached.")
    end

    --- @class GameObject
    local instance = setmetatable({}, GameObject)
    instance:init(
        name,
        Transform.new(
            instance,
            pos or Vector2.new(),
            rotation or 0,
            scale or Vector2.new()
        )
    )
    return instance
end

--- 初期化処理
--- @private
--- @param name string|nil
--- @param transform Transform
function GameObject:init(name, transform)
    -- スーパークラスの初期化
    self.super:init()

    --- @private
    self.name = name or ("GameObject"..#gameobjects)

    --- @private
    self.transform = transform

    --- @private
    --- @type Component[]
    self.components = {}

    table.insert(gameobjects, self)
end


-- ========== metamethod ==========

--- 
--- @return string
function GameObject:__tostring()
    return "GameObjects"
end


-- ========== DeLuataEngine ==========

--- Componentを追加する
--- @param component Component
function GameObject:addComponent(component)
    table.insert(self.components, component)
end

--- Componentを削除する
--- @param componentType Component
function GameObject:removeComponent(componentType)
    
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
    error("Component not found: "..tostring(componentType))
end


--- Gameobjectを破棄する
--- @param obj GameObject
function Destroy(obj)
end

return{
    GameObject=GameObject
}