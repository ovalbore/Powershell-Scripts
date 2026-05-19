# Set export path
$csvPath = "C:\Temp\Shares.csv"

# Create folder if it does not exist
$folder = Split-Path $csvPath
if (-not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
}

# Get all non-default SMB shares
$shares = Get-SmbShare | Where-Object {
    $_.Special -eq $false
}

# Build export data
$results = foreach ($share in $shares) {
    [PSCustomObject]@{
        ShareName  = $share.Name
        FilePath   = $share.Path
        Description = $share.Description
    }
}

# Export CSV
$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Host "Export complete: $csvPath"

# Pause so the window stays open if double-clicked
Pause