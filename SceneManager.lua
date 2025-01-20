--[[
ScenenManagerクラス。ゲームのシーンを制御し、Sceneがあらゆるオブジェクトを管理します。
]]
local Scene = require("abstruct.Scene").Scene

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
    --- シーンキャッシュ
    --- @private
    --- @type Scene[]
    self.scenes = {}

    --- 読み込み中のシーン
    --- @private
    --- @type Scene
    self.currentScene = nil

    --- コルーチン
    --- @private
    self.corutines = {}
end

-- ========== metamethod ==========

--- @private
--- @return string
function SceneManager:__tostring()
    return "SceneManager: currentScene="..tostring(self.currentScene)
end


-- ==========DeLuataEngine==========

--- Sceneの追加
--- @param scene Scene
function SceneManager:addScene(scene)
    self.scenes[scene.name] = scene
end

--- Sceneの削除
--- @param sceneName string
function SceneManager:removeScene(sceneName)
    self.scenes[sceneName] = nil
end

--- Sceneの切り替え
--- @param sceneName string
function SceneManager:changeScene(sceneName)
    -- シーンの切り替えコールバック
    self.currentScene:onChange()

    self.currentScene = self.scenes[sceneName]
    self.currentScene:loadObject()
    self.currentScene:load()
end

function SceneManager:load()
    if self.currentScene then
        self.currentScene:loadObject()
        self.currentScene:load()
    end
end

--- @param dt number
function SceneManager:update(dt)
    -- if self.corutines then
    --     for i, co in ipairs(self.corutines) do
    --         if coroutine.status(co) == "suspended" then
    --             coroutine.resume(co)
    --         elseif coroutine.status(co) == "dead" then
    --             table.remove(self.corutines, i)
    --         end
    --     end
    -- end

    self.currentScene:update(dt)
end

--- 非同期にSceneの切り替え
-- --- @param sceneName string
-- function SceneManager:changeSceneAsync(sceneName)
--     local co = coroutine.create(function ()
--         self.currentScene:onChange()
--         self.currentScene = self.scenes[sceneName]

--         self.currentScene:loadObject()
--         coroutine.yield()

--         self.currentScene:load()
--         coroutine.yield()
--     end)

--     self.corutines = self.corutines or {}
--     table.insert(self.corutines, co)
-- end

--- Sceneの切り替え(Sceneキャッシュモード)


--- 現在のSceneを取得
--- @return Scene
function SceneManager:getCurrentScene()
    return self.currentScene
end

return{
    SceneManager=SceneManager
}