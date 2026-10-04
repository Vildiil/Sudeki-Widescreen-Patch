param(
    [string]$GameDir,
    [ValidateSet('Both','Camera','Restore','')][string]$Mode = ''
)
$ErrorActionPreference = 'Stop'
function BytesHash([byte[]]$Bytes) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { ([BitConverter]::ToString($sha.ComputeHash($Bytes))).Replace('-','').ToLowerInvariant() }
    finally { $sha.Dispose() }
}
function ApplyChanges([byte[]]$Bytes, $Changes, [string]$Field) {
    foreach ($change in $Changes) {
        $part = [Convert]::FromBase64String([string]$change.$Field)
        if ($part.Length -gt 0) {
            [Array]::Copy($part, 0, $Bytes, [int]$change.offset, $part.Length)
        }
    }
}
try {
    if (!$Mode) {
        Write-Host 'Sudeki Widescreen Fixes'
        Write-Host '1. Install camera + HUD fixes (recommended)'
        Write-Host '2. Install camera fix only'
        Write-Host '3. Restore original executable'
        $choice = Read-Host 'Choose 1, 2, or 3 (Enter = 1)'
        $Mode = switch ($choice) { '' {'Both'} '1' {'Both'} '2' {'Camera'} '3' {'Restore'} default { throw 'Invalid choice.' } }
    }
    if (!$GameDir) {
        $GameDir = Read-Host 'Game folder (Enter = C:\GOG Games\Sudeki)'
        if (!$GameDir) { $GameDir = 'C:\GOG Games\Sudeki' }
    }
    if (Get-Process -Name SUDEKI -ErrorAction SilentlyContinue) { throw 'Close Sudeki first, then run this patcher again.' }
    $GameDir = (Resolve-Path -LiteralPath $GameDir).Path
    $target = Join-Path $GameDir 'SUDEKI.exe'
    $backup = Join-Path $GameDir 'SUDEKI.exe.pre-widescreen-fixes.bak'
    $data = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'patch-data.json') -Raw | ConvertFrom-Json
    [byte[]]$current = [IO.File]::ReadAllBytes($target)
    $currentHash = BytesHash $current
    $currentVariant = $null
    if ($currentHash -ne $data.originalHash) {
        foreach ($entry in $data.variants.PSObject.Properties) {
            if ($currentHash -eq $entry.Value.hash) { $currentVariant = $entry.Value; break }
        }
        if (!$currentVariant) { throw 'Unsupported or modified SUDEKI.exe. No files were changed. This patch requires the supported GOG release.' }
    }
    [byte[]]$original = New-Object byte[] ([int]$data.originalLength)
    [Array]::Copy($current, 0, $original, 0, $original.Length)
    if ($currentVariant) { ApplyChanges $original $currentVariant.changes 'original' }
    if ((BytesHash $original) -ne $data.originalHash) { throw 'Original executable verification failed.' }
    if ($Mode -eq 'Restore') {
        [byte[]]$result = $original
        $expected = $data.originalHash
    } else {
        $variant = $data.variants.$Mode
        [byte[]]$result = New-Object byte[] ([int]$variant.length)
        [Array]::Copy($original, 0, $result, 0, $original.Length)
        ApplyChanges $result $variant.changes 'patched'
        $expected = $variant.hash
    }
    if ((BytesHash $result) -ne $expected) { throw 'Patch result verification failed; game was not changed.' }
    if ($currentHash -eq $expected) { Write-Host "Already in the requested state: $Mode"; exit 0 }
    if (Test-Path -LiteralPath $backup) {
        if ((BytesHash ([IO.File]::ReadAllBytes($backup))) -ne $data.originalHash) { throw 'Existing backup is different; refusing to replace it.' }
    } else {
        [IO.File]::WriteAllBytes($backup, $original)
    }
    if ((BytesHash ([IO.File]::ReadAllBytes($backup))) -ne $data.originalHash) { throw 'Backup verification failed.' }
    # Check again in case the file changed while the patch was being prepared.
    if ((BytesHash ([IO.File]::ReadAllBytes($target))) -ne $currentHash) { throw 'Game executable changed during preparation; please retry.' }
    [IO.File]::WriteAllBytes($target, $result)
    if ((BytesHash ([IO.File]::ReadAllBytes($target))) -ne $expected) { throw 'Installation verification failed. Restore the verified backup before launching.' }
    Write-Host "Success: $Mode. Original backup retained in the game folder."
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
