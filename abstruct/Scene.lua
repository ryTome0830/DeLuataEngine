--[[
Sceneクラス。シーンの定義の基底クラスです。
すべてのゲームのオブジェクトやコンポーネントを保持します。
]]

local LogManager = require("LogManager").LogManager.new()

--- @class Scene
--- @field name string シーン名
--- @field gameObject GameObject シーンに含まれるGameObjecctの管理
--- @field gameObjectNum integer シーンに含まれるGameObjecctの数
local Scene = {}
Scene.__index = Scene

--- Sceneコンストラクタ
--- @return Scene
function Scene.new()
    --- @class Scene
    local instance = setmetatable({}, Scene)

    instance:init()
    return instance
end

--- Scene初期化処理
function Scene:init()
    --- @type string
    self.name = nil

    --- @type table<string, GameObject>
    self.gameObjects = {}

    --- @type integer
    self.gameObjectNum = 1
end

--- Sceneクラスの継承
--- @return table
function Scene:extend()
    -- 新しいクラスclsを作成
    --- @class Scene
    local cls = {}
    -- Sceneクラスの'__'で始まるプロパティをコピー
    for k, v in pairs(self) do
        if k:find("__") == 1 then
        cls[k] = v
        end
    end
    -- clsのメタテーブル__indexにclsを設定
    cls.__index = cls
    -- 親クラスの参照を保持
    cls.super = self
    -- cls
    setmetatable(cls, self)
    return cls
end

-- ==========metamethod==========

--- @private
--- @return string
-- function Scene:__tostring()
--     return "Scene: "..self.name
-- end

-- ==========DeLuataEngine==========

--- @private
function Scene:instantiateObject()
    self:onInstantiateObject()
end

--- @param gameObject GameObject
function Scene:addGameObject(gameObject)
    self.gameObjects[gameObject.id] = gameObject
    self.gameObjectNum = self.gameObjectNum + 1
end

--- called SceneManager:load
function Scene:load()
    self:instantiateObject()
    self:onLoad()
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:load()
    end
    LogManager:logDebug("Scene:load")
end

--- called SceneManager:update
function Scene:update(dt)
    self:onUpdate(dt)
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:update(dt)
    end
    LogManager:logDebug("Scene:update")
end

function Scene:destroy()
    self:onDestroy()
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:destroy()
    end

    self.gameObjects = {}
    LogManager:logDebug("Scene:destroy")
end




-- ==========callbacks==========


--- オブジェクトのインスタンス化
function Scene:onInstantiateObject()
end

--- ユーザ定義のロード処理
function Scene:onLoad()
end

--- ユーザ定義の更新処理
function Scene:onUpdate(dt)
end

--- ユーザ定義の破棄処理
function Scene:onDestroy()
end


return{
    Scene=Scene
}