--- @class LogManager
local LogManager = {}
LogManager.__index = LogManager

--- シングルトンオブジェクト
--- @class LogManager
local singleton_object = nil;

--- ログレベル
--- @alias LogLevels
--- | 1 # DEBUG
--- | 2 # INFO
--- | 3 # WARNING
--- | 4 # ERROR
--- | 5 # FATAL

local LogLevels = {
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4,
    FATAL = 5
}

--- @enum Colors
local Colors = {
    RESET = "\027[0m",
    RED = "\027[31m",
    GREEN = "\027[32m",
    YELLOW = "\027[33m",
    BLUE = "\027[34m",
    MAGENTA = "\027[35m",
    CYAN = "\027[36m",
    WHITE = "\027[37m",
}

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

        -- シングルトンオブジェクトの再代入を防ぐ
        setmetatable(singleton_object, {
            __newindex = function(table, key, value)
                error("LogManager is a singleton and cannot be modified.", 2)
            end,
            __index = LogManager
        })
    end
    return singleton_object
end

--- 初期化処理
function LogManager:init()
    --- @private
    --- @type boolean
    self._enabled = true

    --- @type LogLevels
    self._logLevel = LogLevels.DEBUG
end

-- ========== metamethod ==========

--- @private
--- @return string
function LogManager:__tostring()
    return "LogManager"
end

-- ========== DeluataEngine ==========

--- @param enable boolean
function LogManager:setActive(enable)
    self._enabled = enable
end

--- @param logLevel LogLevels
function LogManager:setLogLevel(logLevel)
    if logLevel > #LogLevels then
        return
    end
    self._logLevel = logLevel
end

--- @private
--- @param message string
--- @param color string
--- @param loglevel integer
--- @param stack? string
function LogManager:log(message, color, loglevel, stack)
    if not self._enabled then
        return
    end

    if loglevel < self._logLevel then
        return
    end

    local now = os.date("%Y-%m-%d %H:%M:%S")
    local reset = Colors.RESET
    local formattedMessage = string.format("[%s] [%s] %s", now, loglevel, message)

    if stack then
        print(color .. formattedMessage .. reset.."\n"..stack)
    else
        print(color .. formattedMessage .. reset)
    end

end

--- ログレベル1のログを出力
--- @param message any
function LogManager:logDebug(message)
    self:log(message, Colors.RESET, LogLevels.DEBUG)
end

--- Logレベル2のログを出力
--- @param message any
function LogManager:logInfo(message)
    self:log(message, Colors.WHITE, LogLevels.INFO)
end

--- Logレベル3のログを出力
--- @param message any
function LogManager:logWarning(message)
    self:log(message, Colors.YELLOW, LogLevels.WARNING)
end

--- Logレベル4のログを出力
--- @param message any
function LogManager:logError(message)
    self:log(message, Colors.RED, LogLevels.ERROR, debug.traceback("stack traceback:", 1))
end

--- Logレベル5のログを出力
--- @param message any
function LogManager:logFatal(message)
    self:log(message, Colors.RED, LogLevels.FATAL, debug.traceback("stack traceback", 1))
end

--- グローバルスコープ化
_G.LogManager = LogManager.new()
