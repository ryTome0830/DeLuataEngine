--- あらゆるオブジェクトのディープコピーを生成する
--- @param origin table
--- @return table
function DeepCopy(origin)
    local copy = {}

    for k, v in pairs(origin) do
        --tableが入れ子になっている場合そのtableもディープコピー
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end

    return copy
end
