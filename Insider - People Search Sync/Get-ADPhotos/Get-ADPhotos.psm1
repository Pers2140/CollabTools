
# Test if AD_photos folder exists
function Test-ADPhotosDir{
    if ( -not (Test-Path -path "./AD_photos")){
        write-host "`n AD_photos dir not avalible ... creating now "
        New-item -path "./AD_photos" -ItemType Directory
    }else{
        write-host "path already exists"
    }
}

Test-ADPhotosDir
function Get-ADPhotos{
    write-host "`n`n Getting AD Photos this might take awhile ... `n`n"
    # $users = (Get-ADUser -Filter { Name -like "Barry Brosnon" }  -SearchBase "OU=People,DC=SRI,DC=COM" -properties *).jpegPhoto | set-content './user_photos/photo.jpeg' -AsByteStream`
    $users = Get-ADUser -Filter *   -SearchBase "OU=People,DC=SRI,DC=COM" -properties mail, jpegPhoto |`
    Select-Object `
    @{N="name";E={$_.name}}, `
    mail, `
    jpegPhoto
    
    $users | ForEach-Object { 

    try {

        if ($_.name -ne $null) { $_.name = $_.name }else { $_.name = "" }

        if ($_.jpegPhoto -ne $null){ $_.jpegPhoto | set-content -path "./AD_photos/$($_.mail).jpg" -AsByteStream } else{

            if ($_.sriphoto -ne $null){ $_.sriphoto | set-content -path "./AD_photos/$($_.mail).jpg" -AsByteStream } else{
                
                Write-Host "$($_.name) does not have a photo ... adding default photo instead"
                # set default photo
                Copy-Item "./Get-ADPhotos/default_photo.png" "./$($_.mail).jpg"
            }
        }

        
        }
    catch {

        write-host ` error occured with $($_.name) ...`
    }
    Finally {

        # write-host ` $($_.name) completed ...`
    }
    }

}

# Upload photos to Sharepoint
function Sync-ADPhotos{
    
}
