Import-Module ./Get-ADPhotos, ./Get-MSGraph, ./Update-StaffInfo

# enable Active Directory Module - https://www.varonis.com/blog/powershell-active-directory-module
# import-Module ActiveDirectoryTools 
# Import-Module -Name ActiveDirectory

write-host @"
`n`n Choose a number `n`n 
1. Update users information in insider 
2. Update users photos
3. Get new Bearer token `n`n 
"@

$Answer = Read-Host -Prompt"`n What would you like to do? `n"

switch($Answer) {
    1 
       {
        write-host "`n`n Updating user information in Insider ...`n`n  "
        # Set-UpdatedStaff
        # uploads JSON file to SP
        Start-FileUpload ".\usersObjArray.json" | Select-Object -ExpandProperty fileSystemInfo 
        write-host "`n`n"
       }
    2  {
        write-host "`n`n Updating user Photos in Insider ... `n`n "
        Get-ADPhotos
        Start-FolderUpload .\AD_photos\
        write-host "`n`n"
       }
    3  {
        write-host "`n`n Generating new Bearer token ... `n`n "
        $(Get-UserToken).access_token
        write-host "`n`n"
       }
 }