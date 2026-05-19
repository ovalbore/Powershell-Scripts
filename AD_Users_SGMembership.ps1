Get-ADGroup -Filter 'GroupCategory -eq "Security"' | ForEach-Object {
    $group = $_.Name
    Get-ADGroupMember $_ | Select-Object @{Name='GroupName';Expression={$group}}, Name, SamAccountName, objectClass
} | Export-Csv "C:\Temp\AD_SecurityGroupMembers.csv" -NoTypeInformation -Encoding UTF8