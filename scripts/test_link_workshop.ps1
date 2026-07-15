$scriptPath = Join-Path $PSScriptRoot "link_workshop.ps1"
$oldProjectRoot = $env:PROJECT_ROOT
$oldTestOnly = $env:MINIDORACAT_LINK_WORKSHOP_TEST_ONLY
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ("MinidoracatMiniMapCompatTest-" + [guid]::NewGuid())

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

try {
    $env:PROJECT_ROOT = Split-Path -Parent $PSScriptRoot
    $env:MINIDORACAT_LINK_WORKSHOP_TEST_ONLY = "1"
    . $scriptPath

    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
    $iniPath = Join-Path $tempRoot "compat-test.ini"
    $encoding = New-Object System.Text.UTF8Encoding($false)

    # 不啟動真實 GameServer；本測試只鎖定排序、卸載邊界與 running guard。
    function Get-ServerRunningState { return $false }
    [IO.File]::WriteAllLines($iniPath, @(
        "PublicName=Compat Test",
        "Mods=\Other;\MinidoracatMiniMapCompatFor42;\CompanionDogs;\MinidoracatMiniMapFor42"
    ), $encoding)
    Update-ServerIniMods -IniPath $iniPath
    $modsLine = [IO.File]::ReadAllLines($iniPath, $encoding) | Where-Object { $_ -match '^Mods=' }
    Assert-True ($modsLine -eq "Mods=\Other;\MinidoracatMiniMapFor42;\CompanionDogs;\MinidoracatMiniMapCompatFor42") `
        "Mods= 未依主 MOD -> CompanionDogs -> 相容包排序"

    Update-ServerIniMods -IniPath $iniPath -Remove
    $modsLine = [IO.File]::ReadAllLines($iniPath, $encoding) | Where-Object { $_ -match '^Mods=' }
    Assert-True ($modsLine -eq "Mods=\Other;\MinidoracatMiniMapFor42;\CompanionDogs") `
        "卸載不應移除共用依賴"

    [IO.File]::WriteAllLines($iniPath, @(
        "PublicName=Compat Test",
        "Mods=\Other;\MinidoracatMiniMapFor42;\CompanionDogs;\MinidoracatMiniMapCompatFor42"
    ), $encoding)
    Update-ServerIniMods -IniPath $iniPath -Remove -RemoveUpstream
    $modsLine = [IO.File]::ReadAllLines($iniPath, $encoding) | Where-Object { $_ -match '^Mods=' }
    Assert-True ($modsLine -eq "Mods=\Other;\MinidoracatMiniMapFor42") `
        "選擇移除 CompanionDogs 時仍必須保留主 MOD與其他 MOD"

    # 鎖定互動路由：選 y 才呼叫 CompanionDogs 連結移除，並把同一選擇傳給伺服器流程。
    $removedLabels = @()
    $removeUpstreamAnswer = "y"
    $serverRemove = $false
    $serverRemoveUpstream = $false
    function Read-Host { return $script:removeUpstreamAnswer }
    function Remove-ManagedLink {
        param([string]$LinkPath, [string]$Label)
        $script:removedLabels += $Label
    }
    function Invoke-ServerIniPrompt {
        param([switch]$Remove, [switch]$RemoveUpstream)
        $script:serverRemove = [bool]$Remove
        $script:serverRemoveUpstream = [bool]$RemoveUpstream
    }
    Dismount-Workshop
    Assert-True ($removedLabels -contains "CompanionDogs") "選 y 未移除 CompanionDogs 連結"
    Assert-True ($serverRemove -and $serverRemoveUpstream) "選 y 未傳遞伺服器移除選項"

    $removedLabels = @()
    $removeUpstreamAnswer = "n"
    $serverRemoveUpstream = $true
    Dismount-Workshop
    Assert-True ($removedLabels -notcontains "CompanionDogs") "選 N 不應移除 CompanionDogs 連結"
    Assert-True (-not $serverRemoveUpstream) "選 N 不應移除伺服器 CompanionDogs ID"

    $before = [IO.File]::ReadAllText($iniPath, $encoding)
    function Get-ServerRunningState { return $true }
    Update-ServerIniMods -IniPath $iniPath
    $after = [IO.File]::ReadAllText($iniPath, $encoding)
    Assert-True ($after -eq $before) "GameServer 執行中不應寫入 ini"

    Write-Output "link workshop: order/remove/optional-upstream/running-guard cases passed"
} finally {
    $env:PROJECT_ROOT = $oldProjectRoot
    $env:MINIDORACAT_LINK_WORKSHOP_TEST_ONLY = $oldTestOnly
    if (Test-Path -LiteralPath $tempRoot) {
        $resolvedTemp = [IO.Path]::GetFullPath($tempRoot)
        $tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
        if ($resolvedTemp.StartsWith($tempBase, [StringComparison]::OrdinalIgnoreCase)) {
            Remove-Item -LiteralPath $resolvedTemp -Recurse -Force
        }
    }
}
