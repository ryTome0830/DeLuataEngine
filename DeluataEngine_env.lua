_G.EngineConfig = {
    --- ===== Const =====
    Const = {
        -- GameObjects
        GAMEOBJECT_MAX_NUM = 100,

        --- World
        WORLD_SCALE = 64,
    },
    --- ===== Var ======
    Var = {
        --- Physics
        X_GRAVITY = 0,
        Y_GRAVITY = 9.8,
        WORLD_PHYSICS = true,
    }
}





-- === Const ===
function EngineConfig.Const:__newindex(key, value)
    if key == "GAMEOBJECT_MAX_NUM" then
        LogManager:logWarning("'GAMEOBJECT_MAX_NUM' is a constant and cannot be changed during execution.")
    elseif key == "WORLD_SCALE" then
        LogManager:logWarning("'WORLD_SCALE' is a constant and cannot be changed during execution.")
    end
end

-- === Var ===
function EngineConfig.Var:__newindex(key, value)
    if key == "X_GRAVITY" or key "Y_GRAVITY" then
        if type(value) ~= "number" then
            LogManager:logWarning("'X_GRAVITY, Y_GRAVITY' must be of type 'number'")
            return
        end
    end
    rawset(self, key, value)
end