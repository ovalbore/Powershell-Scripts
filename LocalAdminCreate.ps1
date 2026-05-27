# Define the username and password
$username = "UsernameGoesHere"
$password = "PasswordGoesHere"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Check if the user already exists
$existingUser = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

if ($existingUser) {
    Write-Host "User '$username' already exists." -ForegroundColor Yellow
} else {
    try {
        # Create the local user
        New-LocalUser -Name $username -Password $securePassword -FullName "DisplayNameGoesHere" -Description "Local Admin Account"
        Write-Host "User '$username' created successfully." -ForegroundColor Green

        # Add the user to the Administrators group
        Add-LocalGroupMember -Group "Administrators" -Member $username
        Write-Host "User '$username' added to the Administrators group." -ForegroundColor Green

        # Set the password to never expire
        Get-LocalUser -Name $username | Set-LocalUser -PasswordNeverExpires $true
        Write-Host "Password for '$username' set to never expire." -ForegroundColor Green

    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }
}