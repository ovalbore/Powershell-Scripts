# =========================
# CONFIG
# =========================
$username = "UsernameGoesHere"
$password = "PasswordGoesHere"

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

$displayName = "DisplayNameGoesHere"
$upn = "$username@$env:USERDNSDOMAIN"

# =========================
# CHECK IF DOMAIN CONTROLLER
# =========================
$computerSystem = Get-CimInstance Win32_ComputerSystem
$isDC = $computerSystem.DomainRole -ge 4

Write-Host "DomainRole detected: $($computerSystem.DomainRole)" -ForegroundColor Cyan

if (-not $isDC) {
    Write-Host "This system is NOT a Domain Controller. Exiting script." -ForegroundColor Red
    exit 1
}

Write-Host "Domain Controller confirmed. Continuing..." -ForegroundColor Green

# =========================
# CREATE USER (NO OU REQUIRED)
# =========================

$userCheck = net user $username 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "User '$username' already exists." -ForegroundColor Yellow
    exit 0
}

try {
    net user $username $password /add

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create user."
    }

    net group "Domain Admins" $username /add

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to add user to Domain Admins."
    }

    Write-Host "Domain admin '$username' created successfully." -ForegroundColor Green
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}