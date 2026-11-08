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
assert(#registerCalls == 1, "CompanionDogs 啟用時應只註冊一次")
assert(registerCalls[1][1] == "MinidoracatMiniMapCompatFor42"
    and registerCalls[1][2] == "dog"
    and registerCalls[1][3] == "UI_MinidoracatMiniMapCompat_Dog"
    and registerCalls[1][4] == nil
    and registerCalls[1][5] == "media/textures/Item_MinidoracatMiniMapCompat_Dog.png",
    "CompanionDogs 註冊參數錯誤")

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
assert(#registerCalls == 2 and registerCalls[1][2] == "dog" and registerCalls[2][2] == "horse",
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
    assert(#registerCalls == 2 and #npcCalls == 0, name .. "：動物應照登記、NPC 不登記")
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
