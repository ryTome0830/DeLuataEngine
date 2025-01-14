local Engine_Env = require("DeluataEngine_env")
local Input = require("Input").Input
local Log = require("LogManager").Log
--local SceneManager = require("SceneManger").SceneManager
local Transform = require("Transform").Transform
local Vector2 = require("Vector2").Vector2

--local Animation = require("Animation").Animation

return{
    DeLuataEngine={
        -- エンジンの主要クラス
        Input=Input,
        Log=Log,
        --SceneManager=SceneManager,
        Transform=Transform,
        Vector2=Vector2,

        
        -- animationモジュール
        Animation={

        },
        -- audioモジュール
        Audio={

        },
        -- componentモジュール
        Component={

        },
        -- effectモジュール
        Effect={

        },
        -- functionモジュール
        Function={

        },
        -- mathモジュール
        Math={

        },
        -- obectモジュール
        Object={

        },
        -- UIモジュール
        UI={

        }
    }
}