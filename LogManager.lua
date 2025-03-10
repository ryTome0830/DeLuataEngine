--- @class LogManager
local LogManager = {}
LogManager.__index = LogManager

--- シングルトンオブジェクト
local singleton_object = nil;

--- ログレベル
--- @enum LogLevels
local LogLevels = {
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4,
    FATAL = 5
}

--- カラー
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
    --- @private
    --- @type boolean
    self._enabled = true

    --- @type integer
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

--- @overload fun(logLevel:1)
--- @overload fun(logLevel:2)
--- @overload fun(logLevel:3)
--- @overload fun(logLevel:4)
--- @overload fun(logLevel:5)
--- @param logLevel integer 1 (DEBUG), 2 (INFO), 3 (WARNING), 4 (ERROR), 5 (FATAL)
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
function LogManager:log(message, color, loglevel)
    if not self._enabled then
        return
    end

    if loglevel < self._logLevel then
        return
    end

    local now = os.date("%Y-%m-%d %H:%M:%S")
    local reset = Colors.RESET
    local formattedMessage = string.format("[%s] [%s] %s", now, loglevel, message)
    print(color .. formattedMessage .. reset)
end


--- @param message any
function LogManager:logDebug(message)
    self:log(message, Colors.WHITE, LogLevels.DEBUG)
end

--- @param message any
function LogManager:logWarning(message)
    self:log(message, Colors.YELLOW, LogLevels.WARNING)
end

--- @param message any
function LogManager:logError(message)
    self:log(message, Colors.RED, LogLevels.ERROR)
end


return{
    LogManager=LogManager
}