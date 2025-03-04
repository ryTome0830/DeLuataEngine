
--- @class LogManager
local LogManager = {}

--- シングルトンオブジェクト
local singleton_object = nil;

--- コンストラクタ
--- @private
--- @return LogManager
function LogManager.new()
    -- インスタンスがなければ生成
    if singleton_object == nil then
        --- @class LogManager
        local instance = setmetatable({}, LogManager)
        instance:init()

        singleton_object = instance
    end
    return singleton_object
end

--- 初期化処理
function LogManager:init()
end

return{
    LogManager=LogManager
}