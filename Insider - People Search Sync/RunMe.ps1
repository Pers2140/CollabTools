Import-Module ./Get-ADPhotos, ./Get-MSGraph, ./Update-StaffInfo

# enable Active Directory Module - https://www.varonis.com/blog/powershell-active-directory-module
# import-Module ActiveDirectoryTools 
# Import-Module -Name ActiveDirectory

$env:client_id = '89723cfa-0e2a-4663-b0cd-65b6cb94d5d1'
$env:client_secret = '-Y58Q~2IH5rIcshgQQQ7w1q1ozjFi94w~-CTrb1n'
$env:tenant_id = '8c0ee380-52d5-49f7-a4a2-34cf2be7b0b9'
$env:site_id = '7733831a-48a3-4298-a44b-b87ca6c3b531'

Get-DriveIds
$env:drive_id = Read-Host -Prompt "`n`n What is your drive id? `n"

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
    4  {
        write-host "`n`n Uploading file`n`n "
        $(Get-UserToken).access_token
        write-host "`n`n"
       }
    5  {
        write-host "`n`n Uploading folder`n`n "
        $(Get-UserToken).access_token
        write-host "`n`n"
        }
 }