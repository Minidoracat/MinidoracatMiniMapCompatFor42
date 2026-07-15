-- MinidoracatMiniMapCompat.lua
-- 第三方 MOD 薄型 adapter：只向主 MOD 公開 API 登記已確認的 IsoAnimal group。

local OWN_MOD_ID = "MinidoracatMiniMapCompatFor42"
local api = MinidoracatMiniMapAPI
local missingApiLogged = false

local function isModActive(modId)
    local mods = getActivatedMods()
    for i = 1, mods:size() do
        if mods:get(i - 1) == modId then return true end
    end
    return false
end

local function registerIfActive(modId, group, labelKey, symbolPath, itemPath)
    if not isModActive(modId) then return end
    if api and api.registerAnimalGroup then
        api.registerAnimalGroup(OWN_MOD_ID, group, labelKey, symbolPath, itemPath)
    elseif not missingApiLogged then
        missingApiLogged = true
        print("[MinidoracatMiniMapCompat] registerAnimalGroup API 不存在；請更新 MinidoracatMiniMapFor42")
    end
end

registerIfActive("CompanionDogs", "dog", "UI_MinidoracatMiniMapCompat_Dog", nil,
    "media/textures/Item_MinidoracatMiniMapCompat_Dog.png")
registerIfActive("Horse", "horse", "UI_MinidoracatMiniMapCompat_Horse",
    "media/ui/MinidoracatMiniMapCompat/map_horse.png",
    "media/textures/Item_MinidoracatMiniMapCompat_Horse.png")
