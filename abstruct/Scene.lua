--[[
Sceneクラス。シーンの定義の基底クラスです。
すべてのゲームのオブジェクトやコンポーネントを保持します。
]]

--- @class Scene
--- @field name string シーン名
--- @field gameObjects table<string, GameObject> シーンに含まれるGameObjecctの管理
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
    self.name = "AnonymousScene"

    --- @type table<string, GameObject>
    self.gameObjects = {}

    --- @type integer
    self.gameObjectNum = 0

    --- @type love.World
    self.world = love.physics.newWorld(
        EngineConfig.Var.X_GRAVITY * EngineConfig.Const.WORLD_SCALE,
        EngineConfig.Var.Y_GRAVITY * EngineConfig.Const.WORLD_SCALE,
        EngineConfig.Var.WORLD_PHYSICS
    )

    self.world:setCallbacks(
        function(fixtureA, fixtureB, contact)
            --- @type Collision
            local userDataA = fixtureA:getUserData()
            --- @type Collision
            local userDataB = fixtureB:getUserData()
            userDataA:onCollisionEnter(userDataB, contact)
            userDataB:onCollisionEnter(userDataA, contact)
        end,
        function(fixtureA, fixtureB, contact)
            --- @type Collision
            local userDataA = fixtureA:getUserData()
            --- @type Collision
            local userDataB = fixtureB:getUserData()
            userDataA:onCollisionExit(userDataB, contact)
            userDataB:onCollisionExit(userDataA, contact)
        end
    )
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
function Scene:__tostring()
    return "Scene: "..self.name
end

-- ==========DeLuataEngine==========

--- @return string
function Scene:generateUUID()
    return string.format("%s", self.gameObjectNum + 1)
end

--- オーバーライド禁止
--- @param gameObject GameObject
function Scene:addGameObject(gameObject)
    gameObject.id = self:generateUUID()
    self.gameObjects[gameObject.id] = gameObject
    self.gameObjectNum = self.gameObjectNum + 1
end

--- オーバーライド禁止
function Scene:load()
    self:onLoadInitObject()
    self:onLoad()
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:load()
    end
end

--- オーバーライド禁止
function Scene:update(dt)
    self:onUpdate(dt)
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:update(dt)
    end
end

--- オーバーライド禁止
function Scene:destroy()
    self:onDestroy()
    for _, gameObject in pairs(self.gameObjects) do
        gameObject:destroy()
    end

    self.gameObjects = {}
    self.world = nil
end



-- ==========callbacks==========

--- 初期オブジェクトの読み込み
function Scene:onLoadInitObject()
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