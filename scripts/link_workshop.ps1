# MinidoracatMiniMapCompatFor42 Workshop／mods 符號連結管理

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if ($env:PROJECT_ROOT) {
    $ProjectRoot = $env:PROJECT_ROOT.TrimEnd('\')
} elseif ($PSScriptRoot) {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
} else {
    $ProjectRoot = (Get-Location).Path
}

$ModId = "MinidoracatMiniMapCompatFor42"
$ModSource = Join-Path $ProjectRoot "MOD\$ModId"
$ModContent = Join-Path $ModSource "Contents\mods\$ModId"

$WorkshopDir = Join-Path $env:UserProfile "Zomboid\Workshop"
$WorkshopLink = Join-Path $WorkshopDir $ModId
$ModsDir = Join-Path $env:UserProfile "Zomboid\mods"
$ModsLink = Join-Path $ModsDir $ModId

# no-steam 客戶端／伺服器不掃 Workshop：缺少時補上開發版主 MOD與 Workshop 上游 MOD。
$CoreModSource = "D:\github\MinidoracatMiniMapFor42\MOD\MinidoracatMiniMapFor42\Contents\mods\MinidoracatMiniMapFor42"
$CoreModLink = Join-Path $ModsDir "MinidoracatMiniMapFor42"
$CompanionDogsSource = "D:\SteamLibrary\steamapps\workshop\content\108600\3740052292\mods\CompanionDogs"
$CompanionDogsLink = Join-Path $ModsDir "CompanionDogs"
$HorseSource = "D:\SteamLibrary\steamapps\workshop\content\108600\3661336777\mods\HorseMod"
$HorseLink = Join-Path $ModsDir "Horse"

$ServerIniDir = Join-Path $env:UserProfile "Zomboid\Server"
$ServerModIds = @("MinidoracatMiniMapFor42", "CompanionDogs", "Horse", $ModId)
$ServerModIdsOwn = @($ModId)

if (-not (Test-Path -LiteralPath (Join-Path $ModContent "42\mod.info"))) {
    Write-Host "[錯誤] 找不到 MOD 來源：$ModContent\42\mod.info" -ForegroundColor Red
    Read-Host "按 Enter 結束"
    exit 1
}

function Get-PathEntry {
    param([string]$Path)
    return Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
}

function Test-IsLink {
    param([string]$Path)
    $item = Get-PathEntry $Path
    if (-not $item) { return $false }
    return $item.LinkType -or (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0)
}

function Invoke-ElevatedSymlink {
    param([string]$LinkPath, [string]$Target)
    $linkQuoted = $LinkPath.Replace("'", "''")
    $targetQuoted = $Target.Replace("'", "''")
    $command = "New-Item -ItemType SymbolicLink -Path '$linkQuoted' -Target '$targetQuoted' -Force | Out-Null"
    try {
        $process = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -WindowStyle Hidden -ArgumentList @(
            "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $command
        )
        return $process.ExitCode -eq 0 -and (Get-PathEntry $LinkPath)
    } catch {
        return $false
    }
}

function New-ManagedLink {
    param([string]$LinkPath, [string]$Target, [string]$Label)
    if (-not (Test-Path -LiteralPath $Target)) {
        Write-Host "  [$Label] 找不到來源，跳過：$Target" -ForegroundColor Yellow
        return $false
    }
    if (Get-PathEntry $LinkPath) {
        Write-Host "  [$Label] 已存在，保留不動：$LinkPath" -ForegroundColor DarkGray
        return $true
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $LinkPath) | Out-Null
    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $Target -ErrorAction Stop | Out-Null
        Write-Host "  [$Label] 已建立：$LinkPath -> $Target" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [$Label] 需要管理員權限，正在請求 UAC..." -ForegroundColor Yellow
        if (Invoke-ElevatedSymlink -LinkPath $LinkPath -Target $Target) {
            Write-Host "  [$Label] 已建立（UAC）：$LinkPath -> $Target" -ForegroundColor Green
            return $true
        }
        Write-Host "  [$Label] 建立失敗；可啟用 Windows 開發人員模式後重試" -ForegroundColor Red
        return $false
    }
}

function Remove-ManagedLink {
    param([string]$LinkPath, [string]$Label)
    $item = Get-PathEntry $LinkPath
    if (-not $item) {
        Write-Host "  [$Label] 不存在，跳過" -ForegroundColor DarkGray
        return
    }
    if (-not (Test-IsLink $LinkPath)) {
        Write-Host "  [$Label] 是實體資料夾，為避免刪除資料而保留" -ForegroundColor Yellow
        return
    }
    try {
        $item.Delete()
        Write-Host "  [$Label] 已移除" -ForegroundColor Green
    } catch {
        $pathQuoted = $LinkPath.Replace("'", "''")
        $command = "(Get-Item -LiteralPath '$pathQuoted' -Force).Delete()"
        try {
            Start-Process powershell.exe -Verb RunAs -Wait -WindowStyle Hidden -ArgumentList @(
                "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $command
            ) | Out-Null
        } catch {}
        if (Get-PathEntry $LinkPath) {
            Write-Host "  [$Label] 移除失敗" -ForegroundColor Red
        } else {
            Write-Host "  [$Label] 已移除（UAC）" -ForegroundColor Green
        }
    }
}

function Show-LinkStatus {
    param([string]$LinkPath, [string]$Label)
    $item = Get-PathEntry $LinkPath
    if (-not $item) {
        Write-Host "  [$Label] 未掛載：$LinkPath" -ForegroundColor Yellow
    } elseif (Test-IsLink $LinkPath) {
        Write-Host "  [$Label] 已掛載：$LinkPath -> $($item.Target)" -ForegroundColor Green
    } else {
        Write-Host "  [$Label] 已有實體目錄：$LinkPath" -ForegroundColor Cyan
    }
}

function Select-ServerIni {
    if (-not (Test-Path -LiteralPath $ServerIniDir)) {
        Write-Host "  [伺服器] 找不到設定目錄：$ServerIniDir" -ForegroundColor Yellow
        return $null
    }
    $files = @(Get-ChildItem -LiteralPath $ServerIniDir -Filter "*.ini" -File |
        Where-Object { $_.Name -notlike "*.bak" } | Sort-Object Name)
    if ($files.Count -eq 0) {
        Write-Host "  [伺服器] 找不到 ini" -ForegroundColor Yellow
        return $null
    }
    if ($files.Count -eq 1) { return $files[0].FullName }

    Write-Host ""
    for ($i = 0; $i -lt $files.Count; $i++) {
        Write-Host "  [$($i + 1)] $($files[$i].Name)"
    }
    $choice = Read-Host "選擇要更新的伺服器（Enter 取消）"
    $number = 0
    if (-not [int]::TryParse($choice, [ref]$number) -or $number -lt 1 -or $number -gt $files.Count) {
        return $null
    }
    return $files[$number - 1].FullName
}

function Get-ServerRunningState {
    param([string]$IniPath)
    $serverName = [IO.Path]::GetFileNameWithoutExtension($IniPath)
    try {
        $namePattern = '-servername\s+' + [regex]::Escape($serverName) + '(\s|$)'
        $running = @(Get-CimInstance Win32_Process -Filter "Name='java.exe'" -ErrorAction Stop |
            Where-Object {
                $_.CommandLine -match 'zombie\.network\.GameServer' -and
                ($_.CommandLine -match $namePattern -or
                    ($serverName -eq 'servertest' -and $_.CommandLine -notmatch '-servername\s'))
            })
        return $running.Count -gt 0
    } catch {
        Write-Host "  [伺服器] 無法確認 GameServer 狀態，為避免 ini 被回寫覆蓋，取消寫入" -ForegroundColor Red
        return $null
    }
}

function Update-ServerIniMods {
    param([string]$IniPath, [switch]$Remove, [switch]$RemoveUpstream)
    $running = Get-ServerRunningState -IniPath $IniPath
    if ($null -eq $running) { return }
    if ($running) {
        Write-Host "  [伺服器] $([IO.Path]::GetFileNameWithoutExtension($IniPath)) 正在執行；請先停止再寫入" -ForegroundColor Red
        return
    }

    $encoding = New-Object System.Text.UTF8Encoding($false)
    try {
        $lines = [Collections.Generic.List[string]]::new()
        $lines.AddRange([IO.File]::ReadAllLines($IniPath, $encoding))
    } catch {
        Write-Host "  [伺服器] 讀取失敗：$($_.Exception.Message)" -ForegroundColor Red
        return
    }

    $index = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*Mods\s*=') { $index = $i; break }
    }
    $current = @()
    if ($index -ge 0) {
        $current = @(($lines[$index] -replace '^\s*Mods\s*=', '') -split ';' |
            ForEach-Object { $_.Trim() } | Where-Object { $_ })
    }

    if ($Remove) {
        $removeIds = @($ServerModIdsOwn)
        if ($RemoveUpstream) { $removeIds += "CompanionDogs", "Horse" }
        $updated = @($current | Where-Object { $removeIds -notcontains $_.TrimStart('\') })
    } else {
        $prefix = '\'
        if ($current.Count -gt 0 -and @($current | Where-Object { $_.StartsWith('\') }).Count -eq 0) {
            $prefix = ''
        }
        # 先移除四個目標 ID 的舊位置／錯誤大小寫，再以固定順序追加。
        $updated = @($current | Where-Object { $ServerModIds -notcontains $_.TrimStart('\') })
        foreach ($id in $ServerModIds) { $updated += "$prefix$id" }
    }

    if (($updated -join ';') -eq ($current -join ';')) {
        Write-Host "  [伺服器] $([IO.Path]::GetFileName($IniPath)) 的 Mods= 無需變更" -ForegroundColor DarkGray
        return
    }

    $newLine = "Mods=" + ($updated -join ';')
    if ($index -ge 0) { $lines[$index] = $newLine } else { $lines.Add($newLine) }
    try {
        Copy-Item -LiteralPath $IniPath -Destination "$IniPath.bak" -Force -ErrorAction Stop
        [IO.File]::WriteAllLines($IniPath, $lines, $encoding)
        Write-Host "  [伺服器] 已更新 $([IO.Path]::GetFileName($IniPath))（備份：.ini.bak）" -ForegroundColor Green
        Write-Host "           $newLine" -ForegroundColor DarkGray
    } catch {
        Write-Host "  [伺服器] 寫入失敗：$($_.Exception.Message)" -ForegroundColor Red
    }
}

function Invoke-ServerIniPrompt {
    param([switch]$Remove, [switch]$RemoveUpstream)
    $question = if ($Remove) {
        if ($RemoveUpstream) {
            "是否從 no-steam 伺服器 Mods= 移除本相容包與 CompanionDogs、Horse？(y/N)"
        } else {
            "是否從 no-steam 伺服器 Mods= 移除本相容包？(y/N)"
        }
    } else {
        "是否把主 MOD、CompanionDogs、Horse、本相容包依序加入 no-steam 伺服器 Mods=？(y/N)"
    }
    if ((Read-Host $question) -notmatch '^[Yy]') { return }
    $ini = Select-ServerIni
    if ($ini) {
        Update-ServerIniMods -IniPath $ini -Remove:$Remove -RemoveUpstream:$RemoveUpstream
    }
}

function Mount-Workshop {
    Write-Host ""
    $ownWorkshop = New-ManagedLink -LinkPath $WorkshopLink -Target $ModSource -Label "Workshop"
    $ownMods = New-ManagedLink -LinkPath $ModsLink -Target $ModContent -Label "相容包"
    $core = New-ManagedLink -LinkPath $CoreModLink -Target $CoreModSource -Label "主MOD"
    $dogs = New-ManagedLink -LinkPath $CompanionDogsLink -Target $CompanionDogsSource -Label "CompanionDogs"
    $horse = New-ManagedLink -LinkPath $HorseLink -Target $HorseSource -Label "Horse"
    Write-Host ""
    if ($ownWorkshop -and $ownMods -and $core -and $dogs -and $horse) {
        Write-Host "[完成] Workshop 與 no-steam mods 依賴已可見" -ForegroundColor Green
        Invoke-ServerIniPrompt
    } else {
        Write-Host "[部分完成] 依賴未全部可見，因此不詢問寫入伺服器 ini" -ForegroundColor Yellow
    }
}

function Dismount-Workshop {
    Write-Host ""
    Remove-ManagedLink -LinkPath $WorkshopLink -Label "Workshop"
    Remove-ManagedLink -LinkPath $ModsLink -Label "相容包"
    $removeUpstream = (Read-Host "是否一併移除 CompanionDogs 與 Horse 的 mods 連結？(y/N)") -match '^[Yy]'
    if ($removeUpstream) {
        Remove-ManagedLink -LinkPath $CompanionDogsLink -Label "CompanionDogs"
        Remove-ManagedLink -LinkPath $HorseLink -Label "Horse"
    } else {
        Write-Host "  [保留] CompanionDogs" -ForegroundColor DarkGray
        Write-Host "  [保留] Horse" -ForegroundColor DarkGray
    }
    Write-Host "  [保留] 主 MOD" -ForegroundColor DarkGray
    Write-Host ""
    Invoke-ServerIniPrompt -Remove -RemoveUpstream:$removeUpstream
}

function Show-Status {
    Write-Host ""
    Show-LinkStatus -LinkPath $WorkshopLink -Label "Workshop"
    Show-LinkStatus -LinkPath $ModsLink -Label "相容包"
    Show-LinkStatus -LinkPath $CoreModLink -Label "主MOD"
    Show-LinkStatus -LinkPath $CompanionDogsLink -Label "CompanionDogs"
    Show-LinkStatus -LinkPath $HorseLink -Label "Horse"
    Write-Host ""
}

if ($env:MINIDORACAT_LINK_WORKSHOP_TEST_ONLY -eq "1") { return }

$Host.UI.RawUI.WindowTitle = "$ModId Workshop 連結管理"
while ($true) {
    Clear-Host
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "  $ModId 連結管理" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "  [1] 掛載 Workshop + mods + 缺少的依賴"
    Write-Host "  [2] 卸載本相容包（可選擇一併移除 CompanionDogs 與 Horse）"
    Write-Host "  [3] 查看目前狀態"
    Write-Host "  [Q] 離開"
    Write-Host ""
    $choice = Read-Host "請選擇"
    switch ($choice.ToUpper()) {
        "1" { Mount-Workshop; Read-Host "按 Enter 繼續" }
        "2" { Dismount-Workshop; Read-Host "按 Enter 繼續" }
        "3" { Show-Status; Read-Host "按 Enter 繼續" }
        "Q" { exit 0 }
    }
}
