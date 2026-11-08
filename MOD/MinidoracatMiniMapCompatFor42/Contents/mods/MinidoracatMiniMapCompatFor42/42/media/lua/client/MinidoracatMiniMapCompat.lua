-- MinidoracatMiniMapCompat.lua
-- 第三方 MOD 薄型 adapter：只經主 MOD 公開 API 登記已確認的 IsoAnimal group、NPC 標記（殭屍上的動畫變數），
-- 以及 Dynamic Outposts 前哨站、Random Airdrops HF 空投的地圖標記（registerMarkerProvider）。
-- 後兩者讀第三方 MOD 的私有狀態（使用者 2026-11-08 裁定）：依賴的字串登記在 repo 的 upstream.json，
-- GitHub Action 每天比對 Steam 上游，有變就開 issue。這裡每一步先查型別，對不上就不畫、只 log 一次。

local OWN_MOD_ID = "MinidoracatMiniMapCompatFor42"
local api = MinidoracatMiniMapAPI
local logged = {}

local function logOnce(key, message)
    if logged[key] then return end
    logged[key] = true
    print("[MinidoracatMiniMapCompat] " .. message)
end

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
    else
        logOnce("animalApi", "registerAnimalGroup API missing; please update MinidoracatMiniMapFor42")
    end
end

-- registerNpcTag 有版本欄位（主 MOD docs/addon-api.md 3.20）：型別檢查＋>=，不用 ==（主 MOD 升 v2 時舊相容包照樣能登記）
local function registerNpcIfActive(modId, tag, labelKey, variable)
    if not isModActive(modId) then return end
    if api and type(api.npcApiVersion) == "number" and api.npcApiVersion >= 1
        and type(api.registerNpcTag) == "function" then
        api.registerNpcTag(OWN_MOD_ID, tag, labelKey, variable)
    else
        logOnce("npcApi", "registerNpcTag API missing; NPC dots keep the zombie color, please update MinidoracatMiniMapFor42")
    end
end

registerIfActive("CompanionDogs", "dog", "UI_MinidoracatMiniMapCompat_Dog", nil,
    "media/textures/Item_MinidoracatMiniMapCompat_Dog.png")
registerIfActive("Horse", "horse", "UI_MinidoracatMiniMapCompat_Horse",
    "media/ui/MinidoracatMiniMapCompat/map_horse.png",
    "media/textures/Item_MinidoracatMiniMapCompat_Horse.png")
-- 登記順序決定主 MOD 的預設色（第 1 個天藍、第 2 個綠）
registerNpcIfActive("Bandits2", "bandits", "UI_MinidoracatMiniMapCompat_Bandits", "Bandit")
registerNpcIfActive("ProjectALifeNPCs", "alife", "UI_MinidoracatMiniMapCompat_ALife", "ALifeActor")

--------------------------------------------------------------------------------
-- 地圖標記：Dynamic Outposts 前哨站與感染點（只畫小地圖，世界地圖它自己有畫）、Random Airdrops HF 空投（兩張地圖都畫）
--------------------------------------------------------------------------------
local OUTPOSTS_ID = "claimableoutposts_dynamic_hordes"
local AIRDROPS_ID = "RandomAirdropsHF"
local OWN_UI = "media/ui/MinidoracatMiniMapCompat/"
-- 前哨站圖示借主 MOD 的資源點圖示（同作者、MIT）。對照比照 Dynamic Outposts 的 mapSymbol／type 表；
-- 兩者都認不得時它自己的世界地圖也不畫圖示，這裡同樣不畫
local OUTPOST_GLYPH = {
    food = "food", knifefork = "food", bar = "food", fuel = "gas",
    meds = "medical", medical = "medical", medcross = "medical",
    ammo = "gunstore", gun = "gunstore", weapon = "gunstore",
    industrial = "industry", mechanic = "tools", crafting = "tools",
    agricultural = "farm", construction = "storage", base = "military",
}
-- 圖示色、底盤色、外框色。前哨站比照 Dynamic Outposts 世界地圖：一般米色、已佔領綠、強盜佔據紅
local LOOK = {
    neutral = { 0.12, 0.10, 0.08, 0.93, 0.89, 0.78, 0.42, 0.30, 0.18 },
    claimed = { 1, 1, 1, 0.20, 0.62, 0.30, 0.08, 0.30, 0.12 },
    bandit = { 1, 0.88, 0.88, 0.60, 0.10, 0.10, 0.20, 0.03, 0.03 },
    infested = { 0.95, 0.20, 0.20, 0.08, 0.08, 0.08, 0.80, 0.10, 0.10 },
    airdrop = { 1, 1, 1, 0.12, 0.14, 0.18, 1, 0.80, 0.20 },
}
local REBUILD_MS = 1000

local textures = {}
local function texture(path)
    local t = textures[path]
    if t == nil then
        t = getTexture(path) or false
        textures[path] = t
        if not t then logOnce("tex:" .. path, "marker texture missing: " .. path) end
    end
    return t or nil
end

local function newMarker(id, x, y, glyphPath, look, label)
    local glyph, disc = texture(glyphPath), texture(OWN_UI .. "marker_disc.png")
    if not glyph or not disc then return nil end
    local c = LOOK[look]
    return { id = id, x = x, y = y, texture = glyph, r = c[1], g = c[2], b = c[3], label = label, state = "live",
        badge = { texture = disc, r = c[4], g = c[5], b = c[6], a = 1 }, ring = { r = c[7], g = c[8], b = c[9], a = 1 } }
end

-- 以下照 Dynamic Outposts client/ClaimableOutposts_MapIcons.lua 的 CO_GetMapOutposts、CO_ShouldShowAllMapIcons、
-- CO_GetOutpostStateReadOnly、CO_IsOutpostDiscoveredOnMap、CO_IsOutpostVisibleOnMap、CO_IsInfestationPointActive、
-- CO_GetWorldMapOverlayCache 的判斷重寫（那些是 local 函式拿不到）；只讀不寫它的資料
local function outpostState(CO, id, key)
    local snap = CO.Client and CO.Client.AuthoritativeMapStates
    if type(snap) == "table" and snap[key] ~= nil then return snap[key] end
    local data = ModData.get("ClaimableOutposts")
    local all = type(data) == "table" and data.outposts
    if type(all) ~= "table" then return nil end
    return all[id] or all[key]
end

local function outpostDiscovered(CO, key, player)
    local cache = CO.Client and CO.Client.DiscoveredMapOutposts
    if type(cache) == "table" and cache[key] == true then return true end
    local md = player and player:getModData()
    local found = md and md.ClaimableOutpostsDiscoveredMapOutposts
    return type(found) == "table" and found[key] == true
end

local function infestationActive(infestations, index)
    local v = infestations[tostring(index)]
    if v ~= nil then return v == true end
    if infestations[0] ~= nil or infestations["0"] ~= nil then
        v = infestations[tostring(index - 1)]
        if v ~= nil then return v == true end
        v = infestations[index - 1]
        if v ~= nil then return v == true end
    end
    return infestations[index] == true
end

local function addOutposts(out, player)
    local CO = ClaimableOutposts
    if type(CO) ~= "table" then return end
    if type(CO.GetMapIconsEnabled) == "function" and not CO.GetMapIconsEnabled() then return end
    local client = type(CO.Client) == "table" and CO.Client or {}
    local list = client.AuthoritativeMapOutposts
    if list == nil then list = type(CO.Config) == "table" and CO.Config.Outposts end
    if type(list) ~= "table" then return end
    local showAll
    if client.ServerRevealAllOutposts ~= nil then
        showAll = client.ServerRevealAllOutposts == true
    else
        showAll = type(CO.GetMapIconsShowAll) == "function" and CO.GetMapIconsShowAll() and true or false
    end
    local authorized, eligible = CO.IsPlayerAuthorizedForOutpost, CO.IsInfestationPointEligible
    local policy = type(CO.SatelliteOverridePolicy) == "table" and CO.SatelliteOverridePolicy or nil
    local disabled = policy and type(policy.IsDisabled) == "function" and policy.IsDisabled or nil
    for _, o in ipairs(list) do
        local center = type(o) == "table" and o.id ~= nil and o.center
        if type(center) == "table" and type(center.x) == "number" and type(center.y) == "number" then
            local key = tostring(o.id)
            local state = outpostState(CO, o.id, key)
            if type(state) ~= "table" then state = nil end
            local visible = showAll
                or (state ~= nil and state.claimed == true and player ~= nil and type(authorized) == "function"
                    and authorized(state, player))
                or outpostDiscovered(CO, key, player)
            if visible then
                local glyph = o.mapSymbol ~= nil and OUTPOST_GLYPH[string.lower(tostring(o.mapSymbol))]
                if not glyph and o.type ~= nil then glyph = OUTPOST_GLYPH[string.lower(tostring(o.type))] end
                if glyph then
                    local look = "neutral"
                    if state and state.claimed == true then
                        look = "claimed"
                    elseif state and state.banditOccupied == true and state.banditCleared ~= true then
                        look = "bandit"
                    end
                    out[#out + 1] = newMarker("do:" .. key, center.x, center.y,
                        "media/ui/poi_icons/poi_" .. glyph .. ".png", look)
                end
                local points, infestations = o.infestationPoints, state and state.infestations
                if type(points) == "table" and type(infestations) == "table" then
                    for i, p in ipairs(points) do
                        if type(p) == "table" and type(p.x) == "number" and type(p.y) == "number"
                            and (type(eligible) ~= "function" or eligible(o, p))
                            and infestationActive(infestations, i)
                            and not (disabled and disabled(state, i)) then
                            out[#out + 1] = newMarker("do:" .. key .. ":" .. i, p.x, p.y, OWN_UI .. "infested.png", "infested")
                        end
                    end
                end
            end
        end
    end
end

-- Random Airdrops HF 的座標只在伺服器端 local 表；SpawnAirdrop 先把 { index = spawnIndex } 塞進全域 SpawnedAirdrops，
-- 再呼叫 RandomAirdrops.FlyOver(spawnArea)。包住 FlyOver 記下「index → 座標」，SpawnedAirdrops 還有那筆就畫。
-- 它的伺服器直接呼叫客戶端函式，只有單機能動（作者也寫不支援多人）；多人時這裡永遠沒有資料
local drops = {}

local function recordAirdrop(spawnArea)
    if type(spawnArea) ~= "table" or type(spawnArea.x) ~= "number" or type(spawnArea.y) ~= "number" then return end
    local spawned = SpawnedAirdrops
    local last = type(spawned) == "table" and spawned[#spawned]
    local index = type(last) == "table" and last.index
    if index == nil and type(RandomAirdrops) == "table" then index = RandomAirdrops.spawnIndex end
    if index ~= nil then drops[index] = { spawnArea.x, spawnArea.y } end
end

-- 只在 OnGameStart 包一次（每次載入存檔 Lua 會整個重載，不會重複包）
local function wrapFlyOver()
    local RA = RandomAirdrops
    if type(RA) ~= "table" or type(RA.FlyOver) ~= "function" then
        logOnce("flyOver", "Random Airdrops HF: RandomAirdrops.FlyOver not found, airdrop markers are off")
        return
    end
    local original = RA.FlyOver
    RA.FlyOver = function(spawnArea, ...)
        pcall(recordAirdrop, spawnArea)
        return original(spawnArea, ...)
    end
end

local function addAirdrops(mini, world)
    local spawned = SpawnedAirdrops
    if type(spawned) ~= "table" then return end
    local label
    for i = 1, #spawned do
        local e = spawned[i]
        local d = type(e) == "table" and e.index ~= nil and drops[e.index]
        if d then
            label = label or getText("UI_MinidoracatMiniMapCompat_Airdrop")
            local m = newMarker("ra:" .. tostring(e.index), d[1], d[2], OWN_UI .. "airdrop.png", "airdrop", label)
            mini[#mini + 1] = m
            world[#world + 1] = m
        end
    end
end

local outpostsActive, airdropsActive = isModActive(OUTPOSTS_ID), isModActive(AIRDROPS_ID)
local EMPTY = { revision = 0, markers = {} }
local caches = {}

local function rebuild(c, pn)
    local mini, world = {}, {}
    if outpostsActive then addOutposts(mini, getSpecificPlayer(pn) or getPlayer()) end
    if airdropsActive then addAirdrops(mini, world) end
    c.rev = c.rev + 1
    c.mini = { revision = c.rev, markers = mini }
    c.world = { revision = c.rev, markers = world }
end

-- 主 MOD 每幀、每個表面呼叫；每位玩家每秒最多重建一次，其餘回快取（addon-api.md 3.14：不每幀重建）
local function markerProvider(pn, surface)
    local c = caches[pn]
    if not c then
        c = { at = 0, rev = 0, mini = EMPTY, world = EMPTY, fresh = true }
        caches[pn] = c
    end
    local now = getTimestampMs()
    if c.fresh or now - c.at >= REBUILD_MS or now < c.at then
        c.fresh, c.at = false, now
        local ok, err = pcall(rebuild, c, pn)
        if not ok then
            c.mini, c.world = EMPTY, EMPTY
            logOnce("markers", "outpost/airdrop markers failed (a supported mod may have changed): " .. tostring(err))
        end
    end
    if surface == "mini" then return c.mini end
    return c.world
end

if outpostsActive or airdropsActive then
    if api and type(api.markerApiVersion) == "number" and api.markerApiVersion >= 1
        and type(api.registerMarkerProvider) == "function" then
        api.registerMarkerProvider(OWN_MOD_ID, markerProvider)
        if airdropsActive then Events.OnGameStart.Add(wrapFlyOver) end
    else
        logOnce("markerApi", "registerMarkerProvider API missing; outpost and airdrop markers are off, please update MinidoracatMiniMapFor42")
    end
end
