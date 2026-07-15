-- MinidoracatMiniMapCompat.lua
-- 第三方 MOD 薄型 adapter：只向主 MOD 公開 API 登記已確認的 IsoAnimal group。

local OWN_MOD_ID = "MinidoracatMiniMapCompatFor42"

local function isModActive(modId)
    local mods = getActivatedMods()
    for i = 1, mods:size() do
        if mods:get(i - 1) == modId then return true end
    end
    return false
end

if isModActive("CompanionDogs") then
    local api = MinidoracatMiniMapAPI
    if api and api.registerAnimalGroup then
        api.registerAnimalGroup(OWN_MOD_ID, "dog", "UI_MinidoracatMiniMapCompat_Dog")
    else
        print("[MinidoracatMiniMapCompat] registerAnimalGroup API 不存在；請更新 MinidoracatMiniMapFor42")
    end
end
