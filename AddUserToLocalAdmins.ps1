# Get the currently logged-in user
$currentUser = (Get-CimInstance Win32_ComputerSystem).UserName

if (-not $currentUser) {
    Write-Host "No user is currently logged in."
    exit
}

# Check if the user is already in the local Administrators group
$alreadyMember = Get-LocalGroupMember -Group "Administrators" |
    Where-Object { $_.Name -eq $currentUser }

if ($alreadyMember) {
    Write-Host "$currentUser is already a member of the local Administrators group."
}
else {
    Add-LocalGroupMember -Group "Administrators" -Member $currentUser
    Write-Host "$currentUser has been added to the local Administrators group."
}