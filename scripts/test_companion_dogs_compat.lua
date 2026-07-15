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
local api = {
    registerAnimalGroup = function(owner, group, labelKey, symbolPath, itemPath)
        registerCalls[#registerCalls + 1] = { owner, group, labelKey, symbolPath, itemPath }
        return true
    end,
}

local messages = run({ "MinidoracatMiniMapFor42" }, api)
assert(#registerCalls == 0, "受支援 MOD 未啟用時不應註冊")
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
