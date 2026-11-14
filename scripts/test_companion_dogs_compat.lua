local sourcePath = arg[1]
    or "MOD/MinidoracatMiniMapCompatFor42/Contents/mods/MinidoracatMiniMapCompatFor42/42/media/lua/client/MinidoracatMiniMapCompat.lua"

local file = assert(io.open(sourcePath, "rb"))
local source = file:read("*a")
file:close()

local compile = loadstring or load

local function run(activeMods, api)
    local oldGetActivatedMods = getActivatedMods
    local oldAPI = MinidoracatMiniMapAPI
    local oldPrint = print
    local messages = {}

    getActivatedMods = function()
        return {
            size = function() return #activeMods end,
            get = function(_, index) return activeMods[index + 1] end,
        }
    end
    MinidoracatMiniMapAPI = api
    print = function(message) messages[#messages + 1] = tostring(message) end

    local chunk, compileErr = compile(source, "@" .. sourcePath)
    assert(chunk, compileErr)
    local ok, runtimeErr = pcall(chunk)

    getActivatedMods = oldGetActivatedMods
    MinidoracatMiniMapAPI = oldAPI
    print = oldPrint

    assert(ok, runtimeErr)
    return messages
end

local registerCalls = {}
local npcCalls = {}
local api = {
    registerAnimalGroup = function(owner, group, labelKey, symbolPath, itemPath)
        registerCalls[#registerCalls + 1] = { owner, group, labelKey, symbolPath, itemPath }
        return true
    end,
    npcApiVersion = 1,
    registerNpcTag = function(owner, tag, labelKey, variable)
        npcCalls[#npcCalls + 1] = { owner, tag, labelKey, variable }
        return true
    end,
}

local messages = run({ "MinidoracatMiniMapFor42" }, api)
assert(#registerCalls == 0 and #npcCalls == 0, "受支援 MOD 未啟用時不應註冊")
assert(#messages == 0, "受支援 MOD 未啟用時應安靜 no-op")

registerCalls = {}
run({ "MinidoracatMiniMapFor42", "CompanionDogs" }, api)
assert(#registerCalls == 2, "CompanionDogs 啟用時應註冊狗與狼各一次")
assert(registerCalls[1][1] == "MinidoracatMiniMapCompatFor42"
    and registerCalls[1][2] == "dog"
    and registerCalls[1][3] == "UI_MinidoracatMiniMapCompat_Dog"
    and registerCalls[1][4] == nil
    and registerCalls[1][5] == "media/textures/Item_MinidoracatMiniMapCompat_Dog.png",
    "CompanionDogs 註冊參數錯誤")
assert(registerCalls[2][2] == "wolf"
    and registerCalls[2][3] == "UI_MinidoracatMiniMapCompat_Wolf"
    and registerCalls[2][4] == "media/ui/MinidoracatMiniMapCompat/map_wolf.png"
    and registerCalls[2][5] == "media/textures/Item_MinidoracatMiniMapCompat_Wolf.png",
    "CompanionDogs 的狼註冊參數錯誤")

registerCalls = {}
run({ "MinidoracatMiniMapFor42", "Horse" }, api)
assert(#registerCalls == 1, "Horse 啟用時應只註冊一次")
assert(registerCalls[1][1] == "MinidoracatMiniMapCompatFor42"
    and registerCalls[1][2] == "horse"
    and registerCalls[1][3] == "UI_MinidoracatMiniMapCompat_Horse"
    and registerCalls[1][4] == "media/ui/MinidoracatMiniMapCompat/map_horse.png"
    and registerCalls[1][5] == "media/textures/Item_MinidoracatMiniMapCompat_Horse.png",
    "Horse 註冊參數錯誤")

registerCalls = {}
run({ "CompanionDogs", "Horse" }, api)
assert(#registerCalls == 3 and registerCalls[1][2] == "dog" and registerCalls[2][2] == "wolf"
    and registerCalls[3][2] == "horse",
    "兩個上游 MOD 同時啟用時應各註冊一次且順序固定")

messages = run({ "CompanionDogs", "Horse" }, nil)
assert(#messages == 1 and messages[1]:find("registerAnimalGroup", 1, true),
    "舊版主 MOD 缺少 API 時應留下可診斷訊息")

print("animal compat: inactive/dog/horse/both/missing-api cases passed")

local BANDITS = { "MinidoracatMiniMapCompatFor42", "bandits", "UI_MinidoracatMiniMapCompat_Bandits", "Bandit" }
local ALIFE = { "MinidoracatMiniMapCompatFor42", "alife", "UI_MinidoracatMiniMapCompat_ALife", "ALifeActor" }
local function sameCall(call, want)
    return #call == #want and call[1] == want[1] and call[2] == want[2] and call[3] == want[3] and call[4] == want[4]
end

npcCalls, registerCalls = {}, {}
messages = run({ "MinidoracatMiniMapFor42", "Bandits2" }, api)
assert(#npcCalls == 1 and sameCall(npcCalls[1], BANDITS) and #registerCalls == 0 and #messages == 0,
    "只啟用 Bandits 時應只登記 bandits 一次")

npcCalls = {}
run({ "MinidoracatMiniMapFor42", "ProjectALifeNPCs" }, api)
assert(#npcCalls == 1 and sameCall(npcCalls[1], ALIFE), "只啟用 Project A-Life 時應只登記 alife 一次")

-- 主 MOD 依登記順序給預設色：Bandits 一定先登記，與 Mods= 排序無關
npcCalls = {}
run({ "ProjectALifeNPCs", "Bandits2" }, api)
assert(#npcCalls == 2 and sameCall(npcCalls[1], BANDITS) and sameCall(npcCalls[2], ALIFE),
    "兩個 NPC MOD 都啟用時應各登記一次，Bandits 在前")

-- 舊主 MOD：有動物 API、沒有 NPC API（或版本欄位不是數字）→ 動物照登記，NPC 只 log 一次、不 crash
local function oldMain(extra)
    local t = { registerAnimalGroup = api.registerAnimalGroup }
    for k, v in pairs(extra or {}) do t[k] = v end
    return t
end
local allMods = { "CompanionDogs", "Horse", "Bandits2", "ProjectALifeNPCs" }
for name, old in pairs({
    noVersion = oldMain({ registerNpcTag = api.registerNpcTag }),
    noFunction = oldMain({ npcApiVersion = 1 }),
    stringVersion = oldMain({ npcApiVersion = "1", registerNpcTag = api.registerNpcTag }),
    versionZero = oldMain({ npcApiVersion = 0, registerNpcTag = api.registerNpcTag }),
}) do
    npcCalls, registerCalls = {}, {}
    messages = run(allMods, old)
    assert(#registerCalls == 3 and #npcCalls == 0, name .. "：動物應照登記、NPC 不登記")
    assert(#messages == 1 and messages[1]:find("registerNpcTag", 1, true), name .. "：NPC API 不足應只 log 一次")
end

-- 新版主 MOD（npcApiVersion > 1）照樣登記：守衛用 >=，不用 ==
npcCalls = {}
messages = run({ "Bandits2" }, oldMain({ npcApiVersion = 2, registerNpcTag = api.registerNpcTag }))
assert(#npcCalls == 1 and #messages == 0, "npcApiVersion 2 應照樣登記")

-- 主 MOD API 整個缺席：動物、NPC 各 log 一次，共 2 行
messages = run(allMods, nil)
assert(#messages == 2 and messages[1]:find("registerAnimalGroup", 1, true)
    and messages[2]:find("registerNpcTag", 1, true), "API 缺席時動物與 NPC 各 log 一次")

print("npc compat: bandits/alife/both-order/old-main/v2/missing-api cases passed")

-- 地圖標記：Dynamic Outposts 前哨站／感染點（只畫小地圖）、Random Airdrops HF 空投（兩張地圖都畫）
local providers, gameStart = {}, {}
Events = { OnGameStart = { Add = function(fn) gameStart[#gameStart + 1] = fn end } }
local markerApi = {
    markerApiVersion = 3,
    registerMarkerProvider = function(owner, fn) providers[#providers + 1] = { owner, fn } end,
}
local clock = 5000
getTimestampMs = function() return clock end
local TEX, noTexture = {}, {}
getTexture = function(path)
    if noTexture[path] then return nil end
    TEX[path] = TEX[path] or { path = path }
    return TEX[path]
end
getText = function(key) return "T:" .. key end
local player = { md = {} }
function player:getModData() return self.md end
getSpecificPlayer = function(pn) if pn == 0 then return player end end
getPlayer = function() return player end
local globalModData = {}
ModData = { get = function(key) return globalModData[key] end }
local function capture(fn)
    local old, out = print, {}
    print = function(message) out[#out + 1] = tostring(message) end
    local ok, err = pcall(fn)
    print = old
    assert(ok, err)
    return out
end
local function tick() clock = clock + 1000 end
local function texPath(m) return m.texture and m.texture.path end

messages = run({ "MinidoracatMiniMapFor42", "Bandits2" }, markerApi)
assert(#providers == 0 and #gameStart == 0, "沒啟用前哨站或空投 MOD 時不應登記 marker provider")

-- 前哨站：照 Dynamic Outposts 的規則判斷誰看得到（已發現、已佔領且有權限、全部顯示），圖示照 mapSymbol 再看 type
local function outpostsFixture()
    ClaimableOutposts = {
        Config = { Outposts = {
            { id = "a", type = "food", center = { x = 100, y = 200 } },
            { id = "b", type = "fuel", center = { x = 110, y = 210 } },
            { id = "c", type = "ammo", center = { x = 120, y = 220 } },
            { id = "d", type = "food", mapSymbol = "MedCross", center = { x = 130, y = 230 } },
            { id = "e", type = "unknown", center = { x = 140, y = 240 }, infestationPoints = {
                { x = 141, y = 241 }, { x = 142, y = 242 }, { x = 143, y = 243 }, { x = 144, y = 244 } } },
            { id = "f", type = "fuel", center = { x = 150, y = 250 } },
            { id = "g", type = "bar", center = { x = 160, y = 260 } },
        } },
        Client = { DiscoveredMapOutposts = { a = true, e = true, f = true } },
        IsPlayerAuthorizedForOutpost = function(state, p) return p == player and state.owner == "me" end,
        IsInfestationPointEligible = function(_, p) return p.x ~= 143 end,
        SatelliteOverridePolicy = { IsDisabled = function(_, i) return i == 4 end },
    }
    player.md = { ClaimableOutpostsDiscoveredMapOutposts = { d = true } }
    -- 感染點是 0 起算的表：第 1 點＝[0] 開、第 2 點＝[1] 關、第 3 點＝[2] 開但不符資格、第 4 點＝[3] 開但被衛星覆寫關掉
    globalModData.ClaimableOutposts = { outposts = {
        c = { claimed = true, owner = "me" },
        d = { banditOccupied = true },
        e = { infestations = { [0] = true, [1] = false, [2] = true, [3] = true } },
        f = { banditOccupied = true, banditCleared = true },
        g = { claimed = true, owner = "them" },
    } }
end
outpostsFixture()
providers = {}
messages = run({ "claimableoutposts_dynamic_hordes" }, markerApi)
assert(#providers == 1 and providers[1][1] == "MinidoracatMiniMapCompatFor42" and #gameStart == 0 and #messages == 0,
    "只啟用 Dynamic Outposts 時應登記一個 provider、不掛空投")
local provider = providers[1][2]
local res = provider(0, "mini")
local m = res.markers
assert(#m == 5, "前哨站應畫 a、c、d、e 的第 1 個感染點與 f，實際 " .. #m)
assert(m[1].id == "do:a" and m[1].x == 100 and m[1].y == 200 and texPath(m[1]) == "media/ui/poi_icons/poi_food.png"
    and m[1].badge.r == 0.93 and m[1].badge.texture.path == "media/ui/MinidoracatMiniMapCompat/marker_disc.png",
    "已發現的前哨站畫一般米色")
assert(m[2].id == "do:c" and texPath(m[2]) == "media/ui/poi_icons/poi_gunstore.png" and m[2].badge.r == 0.20,
    "沒發現但已佔領且有權限的前哨站畫綠色")
assert(m[3].id == "do:d" and texPath(m[3]) == "media/ui/poi_icons/poi_medical.png" and m[3].badge.r == 0.60,
    "玩家 ModData 記著已發現、強盜佔據的前哨站畫紅色，mapSymbol 優先於 type")
assert(m[4].id == "do:e:1" and m[4].x == 141 and texPath(m[4]) == "media/ui/MinidoracatMiniMapCompat/infested.png",
    "類型認不得的前哨站不畫本體，但感染點照畫；關的、不符資格、被覆寫的感染點不畫")
assert(m[5].id == "do:f" and texPath(m[5]) == "media/ui/poi_icons/poi_gas.png" and m[5].badge.r == 0.93,
    "強盜已清除的前哨站回到一般米色")
assert(#provider(0, "world").markers == 0, "前哨站不畫在世界地圖（它自己有畫）")
assert(provider(0, "mini") == res, "一秒內應回同一份快取")
clock = clock + 999
assert(provider(0, "mini") == res, "未滿一秒不重建")
tick()
local res2 = provider(0, "mini")
assert(res2 ~= res and res2.revision > res.revision, "滿一秒重建並遞增 revision")

-- 伺服器送來的清單與狀態優先於 Config／ModData；伺服器說全部顯示時不看發現紀錄
ClaimableOutposts.Client.AuthoritativeMapOutposts = { { id = "z", type = "bar", center = { x = 1, y = 2 } } }
ClaimableOutposts.Client.AuthoritativeMapStates = { z = { claimed = true } }
ClaimableOutposts.Client.ServerRevealAllOutposts = true
tick()
m = provider(0, "mini").markers
assert(#m == 1 and m[1].id == "do:z" and texPath(m[1]) == "media/ui/poi_icons/poi_food.png" and m[1].badge.r == 0.20,
    "權威清單與狀態優先，全部顯示時沒發現也畫")
ClaimableOutposts.GetMapIconsEnabled = function() return false end
tick()
assert(#provider(0, "mini").markers == 0, "玩家在 Dynamic Outposts 關掉地圖圖示時不畫")

-- 它的函式出錯：不往外丟、清空標記、只 log 一次
ClaimableOutposts.GetMapIconsEnabled = function() error("boom") end
local logs = capture(function()
    tick(); assert(#provider(0, "mini").markers == 0)
    tick(); assert(#provider(0, "mini").markers == 0)
end)
assert(#logs == 1 and logs[1]:find("markers failed", 1, true), "上游出錯只 log 一次")

-- 主 MOD 的資源點圖示不見：該標記不畫，只 log 一次
outpostsFixture()
noTexture["media/ui/poi_icons/poi_food.png"] = true
providers = {}
run({ "claimableoutposts_dynamic_hordes" }, markerApi)
logs = capture(function()
    m = providers[1][2](0, "mini").markers
    tick(); providers[1][2](0, "mini")
end)
assert(#m == 4 and m[1].id == "do:c" and #logs == 1 and logs[1]:find("poi_food", 1, true), "缺圖示的標記略過並 log 一次")
noTexture = {}

-- 空投：包住 RandomAirdrops.FlyOver 記座標，SpawnedAirdrops 還有那筆就在兩張地圖畫
local flown = {}
RandomAirdrops = { FlyOver = function(area, extra) flown[#flown + 1] = { area, extra }; return "orig" end }
SpawnedAirdrops = {}
providers, gameStart = {}, {}
messages = run({ "RandomAirdropsHF" }, markerApi)
assert(#providers == 1 and #gameStart == 1 and #messages == 0, "啟用空投 MOD 時登記 provider，進遊戲時才包 FlyOver")
gameStart[1]()
SpawnedAirdrops[1] = { index = 7 }
assert(RandomAirdrops.FlyOver({ x = 10640, y = 10438, z = 0 }, "x") == "orig" and #flown == 1 and flown[1][2] == "x",
    "包過的 FlyOver 照原樣呼叫一次原函式並傳回結果")
provider = providers[1][2]
m = provider(0, "mini").markers
assert(#m == 1 and m[1].id == "ra:7" and m[1].x == 10640 and m[1].y == 10438
    and texPath(m[1]) == "media/ui/MinidoracatMiniMapCompat/airdrop.png" and m[1].label == "T:UI_MinidoracatMiniMapCompat_Airdrop",
    "空投畫在記下的座標並帶名稱")
assert(provider(0, "world").markers[1] == m[1], "空投也畫在世界地圖")
SpawnedAirdrops[2] = { index = 3 }
tick()
assert(#provider(0, "mini").markers == 1, "沒經過 FlyOver 的空投沒有座標，不畫")
table.remove(SpawnedAirdrops, 1)
tick()
assert(#provider(0, "mini").markers == 0, "空投從 SpawnedAirdrops 消失後就不畫")
assert(RandomAirdrops.FlyOver(nil) == "orig" and #flown == 2, "參數不對也照樣呼叫原函式")

RandomAirdrops = {}
providers, gameStart = {}, {}
run({ "RandomAirdropsHF" }, markerApi)
logs = capture(function() gameStart[1](); gameStart[1]() end)
assert(#logs == 1 and logs[1]:find("FlyOver not found", 1, true), "FlyOver 不見時只 log 一次")

-- 兩個都啟用：小地圖有前哨站與空投，世界地圖只有空投；主 MOD 太舊時只 log 一次
outpostsFixture()
RandomAirdrops = { FlyOver = function() return "orig" end }
SpawnedAirdrops = { { index = 1 } }
providers, gameStart = {}, {}
run({ "claimableoutposts_dynamic_hordes", "RandomAirdropsHF" }, markerApi)
gameStart[1]()
RandomAirdrops.FlyOver({ x = 5, y = 6 })
provider = providers[1][2]
assert(#provider(0, "mini").markers == 6 and #provider(0, "world").markers == 1, "兩個都啟用時各畫各的")
messages = run({ "claimableoutposts_dynamic_hordes", "RandomAirdropsHF" }, { markerApiVersion = 0 })
assert(#messages == 1 and messages[1]:find("registerMarkerProvider", 1, true), "主 MOD 沒有 marker API 時只 log 一次")

print("marker compat: outposts/infestation/authoritative/disabled/errors/missing-texture/airdrops/both/missing-api cases passed")
