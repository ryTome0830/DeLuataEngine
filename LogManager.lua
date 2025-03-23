--- @class LogManager
local LogManager = {}
LogManager.__index = LogManager

--- シングルトンオブジェクト
--- @class LogManager
local singleton_object = nil;

--- ログレベル
--- @alias LogLevels
--- | 1 # INFO
--- | 2 # DEBUG
--- | 3 # WARNING
--- | 4 # ERROR
--- | 5 # FATAL

local LogLevels = {
    INFO = 1,
    DEBUG = 2,
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
        singleton_object = setmetatable({}, LogManager)
        singleton_object:init()
    end
    return singleton_object
end

--- 初期化処理
function LogManager:init()
    --- @private
    --- @type boolean
    self._enabled = true

    --- @private
    --- @type LogLevels
    self._logLevel = LogLevels.INFO
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

    -- ログメソッドの強度が現在のログレベルよりも小さいとき出力を停止
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

--- Logレベル1のログを出力
--- @param message any
function LogManager:logInfo(message)
    self:log(message, Colors.RESET, LogLevels.INFO)
end

--- ログレベル2のログを出力
--- @param message any
function LogManager:logDebug(message)
    self:log(message, Colors.WHITE, LogLevels.DEBUG)
end

--- Logレベル3のログを出力
--- @param message any
function LogManager:logWarning(message)
    self:log(message, Colors.YELLOW, LogLevels.WARNING)
end

--- Logレベル4のログを出力
--- @param message any
function LogManager:logError(message)
    self:log(message, Colors.RED, LogLevels.ERROR, debug.traceback("DeLuataEngine", 3))
end

--- Logレベル5のログを出力
--- @param message any
function LogManager:logFatal(message)
    self:log(message, Colors.RED, LogLevels.FATAL, debug.traceback("DeLuataEngine", 3))
end

--- GameObjectデバッグ出力
--- @param gameObject GameObject
function LogManager:dumpGameObject(gameObject)
    -- component出力
    local components = ""
    for _, component in pairs(gameObject.components) do
        components = components..tostring(component)
    end

    -- children出力
    local children = ""
    for _, child in ipairs(gameObject.transform:getChild()) do
        children = children..tostring(child)
    end


    -- GameObject: <name> [uuid=<id>]
    -- Transform(pos: (<x>, <y>), rotation: <rotation>, scale: (<x>, <y>))
    -- Components{
    -- }
    -- Children{
    -- }
    self:logDebug(string.format(
[[
%s
    %s
    Components{
        %s
    }
    Children{
        %s
    }
]],
gameObject,
gameObject.transform,
components,
children
        )
    )
end

--- tableを展開して出力する
--- @param t table
--- @param indent? string
function LogManager:ShowTable(t, indent)
    indent = indent or ""
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent.."["..tostring(k).."] = table:")
            self:ShowTable(v, indent.."  ")
        else
            print(indent.."["..tostring(k).."] = "..tostring(v))
        end
    end
end

--- グローバルスコープ化
_G.LogManager = LogManager.new()
