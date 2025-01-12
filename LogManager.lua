
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
    -- 現在のログレベル
    self.currentLogLevel = LogLevel.DEBUG
end

--- ログ標準出力関数
--- @param logLevel LogLevel
--- @param message string
function LogManager:log(logLevel, message)
    if logLevel >= self.currentLogLevel then
        local logLevelStr = ""
        if logLevel == LogLevel.DEBUG then
            logLevelStr = "DEBUG"
        elseif logLevel == LogLevel.INFO then
            logLevelStr = "INFO"
        elseif logLevel == LogLevel.WARNING then
            logLevelStr = "WARNING"
        end

        local formattedMessage = string.format("[%s] %s", logLevelStr, message)
        print(formattedMessage)
    end
end

--- エラーログ出力
--- @param message string
function LogManager:logError(message)
    local trace = debug.traceback()
    local formattedMessage = string.format(("[ERROR] %s\n%s"), message, trace)
    print(formattedMessage)
end

return{
    LogManager=LogManager
}