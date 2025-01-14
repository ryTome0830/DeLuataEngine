--[[
Sceneクラス。すべてのゲームのオブジェクトやコンポーネントを保持します。
]]
--- @class Scene
local Scene = {}
Scene.__index = Scene

-- Sceneインスタンスを保持
local sceneInstance = nil

--- Sceneコンストラクタ
--- @param name string
--- @return Scene
function Scene.new(name)
    if sceneInstance == nil then
        --- @class Scene
        local instance = setmetatable({}, Scene)
        instance:init(name)
        sceneInstance = instance
    end
    return sceneInstance
end

--- Scene初期化処理
--- @param name string
function Scene:init(name)
    -- シーンの初期化処理
    self.name = name
    --- @type GameObject[]
    self.gameObjects = {}
end

-- ========== metamethod ==========

--- @return string
function Scene:__tostring()
    return "Scene: "..self.name
end

--- シーン内のすべてのGameObjectをロード
--- love.load, SceneManager:loadSceneで呼ばれる
function Scene:load()
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:load()
    end
end

--- シーン内のすべてのGameObjectを更新
--- love.updateでよばれる
function Scene:update(dt)
    -- オブジェクトの更新
    -- object:update(dt)を呼ぶ
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:update(dt)
    end
end

--- シーン内のすべてのGameObjectを描画
function Scene:draw()
    -- オブジェクトの描画
    -- object:draw()を呼ぶ
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:draw()
    end
end

--- シーンの破棄
function Scene:destroy()
    -- object:destroyを呼ぶ
    for _, gameObject in ipairs(self.gameObjects) do
        gameObject:destroy()
    end
    self.gameObjects = nil
end

--- シーン内のGameObjectの数を取得
--- @return number
function Scene:getGameObjectNum()
    return #self.gameObjects
end

--- シーンにGameObjectを追加
--- @param gameObject GameObject
function Scene:addGameObject(gameObject)
    table.insert(self.gameObjects, gameObject)
end

--- シーンからGameObjectを破棄
--- @param gameObject GameObject
function Scene:removeGameObject(gameObject)
    for i, obj in ipairs(self.gameObjects) do
        if obj == gameObject then
            table.remove(self.gameObjects, i)
        end
    end
end

--- シーンからGameObjectを名前で取得
--- @param objectName string
--- @return GameObject|nil
function Scene:FindObject(objectName)
    for _, obj in ipairs(self.gameObjects) do
        if obj.name == objectName then
            return obj
        end
    end
    return nil
end

--- シーンからGameObjectをタグで検索

--- シーンからGameObjectをレイヤーで検索

--- すべてのゲームオブジェクトを取得
--- @return GameObject[]
function Scene:GetAllGameObjecs()
    return self.gameObjects
end

-- ==========CallBacks==========

function Scene:onLoad()
end

function Scene:onDestroy()
end


--[[
ScenenManagerクラス。ゲームのシーンを制御し、Sceneがあらゆるオブジェクトを管理します。
]]
--- @class SceneManager
local SceneManager = {}
SceneManager.__index = SceneManager

-- シングルトンインスタンス
local SceneManagerInstance = nil

--- SceneManagerコンストラクタ
--- @return SceneManager
function SceneManager.new()
    if SceneManagerInstance == nil then
        --- @class SceneManager
        local instance = setmetatable({}, SceneManager)
        instance:init()
        SceneManagerInstance = instance
    end
    return SceneManagerInstance
end

--- 初期化処理
function SceneManager:init()
    --- @private
    --- @type Scene[]
    self.scenes = {}
    --- @private
    --- @type Scene
    self.currentScene = nil
end

-- ========== metamethod ==========

--- @return string
function SceneManager:__tostring()
    local tableContent;
    for key, _ in pairs(self.scenes) do
        tableContent = tableContent..key
    end
    return "SceneManager: ".."scenes{"..tableContent.."}"
end

--- シーンを追加
--- @param sceneName string
--- @return Scene
function SceneManager:registerScene(sceneName)
    local newScene = Scene.new(sceneName)
    self.scenes[sceneName] = newScene
    return newScene
end

--- 現在のシーンを取得
--- @return Scene
function SceneManager:getCurrentScene()
    return self.currentScene
end

--- シーンの切り替え
--- @param sceneName string
function SceneManager:changeScene(sceneName)
    -- 次のシーンが存在するか
    if not self.scenes[sceneName] then
        print("Scene to change to not found")
    end

    -- 新しいシーンの生成
    self.currentScene = self.scenes[sceneName]
    -- 読み込み
    self:loadScene()
end

--‐ シーンの読み込み
function SceneManager:loadScene()
    if self.currentScene then
        self.currentScene:destroy()
    else
        error("Current scene is not defined")
    end
    self.currentScene:load()
end

--- シーンの更新
--- @param dt number
function SceneManager:updateScene(dt)
    if self.currentScene then
        self.currentScene:update(dt)
    end
end

--- シーンの描画
function SceneManager:drawScene()
    if self.currentScene then
        self.currentScene:draw()
    end
end

return{
    SceneManager=SceneManager
}