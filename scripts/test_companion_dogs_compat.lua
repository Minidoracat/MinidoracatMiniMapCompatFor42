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
    registerAnimalGroup = function(owner, group, labelKey)
        registerCalls[#registerCalls + 1] = { owner, group, labelKey }
        return true
    end,
}

local messages = run({ "MinidoracatMiniMapFor42" }, api)
assert(#registerCalls == 0, "CompanionDogs 未啟用時不應註冊 dog")
assert(#messages == 0, "CompanionDogs 未啟用時應安靜 no-op")

run({ "MinidoracatMiniMapFor42", "CompanionDogs" }, api)
assert(#registerCalls == 1, "CompanionDogs 啟用時應只註冊一次")
assert(registerCalls[1][1] == "MinidoracatMiniMapCompatFor42"
    and registerCalls[1][2] == "dog"
    and registerCalls[1][3] == "UI_MinidoracatMiniMapCompat_Dog",
    "CompanionDogs 註冊參數錯誤")

messages = run({ "CompanionDogs" }, nil)
assert(#messages == 1 and messages[1]:find("registerAnimalGroup", 1, true),
    "舊版主 MOD 缺少 API 時應留下可診斷訊息")

print("companion dogs compat: inactive/active/missing-api cases passed")
