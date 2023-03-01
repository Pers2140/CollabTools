

# fetches Users from AD and creates toUploadUsers.json file
function Set-UpdatedStaff {
    # sriDepartmentName lookup
    $sriDepartmentName = @{
        "052035" = "AR Counties 1"
        "052036" = "AR Counties 2"
        "052037" = "Arkansas Counties of Benton C"
        "052049" = "California Counties of Montere"
        "052051" = "California Counties of Alameda"
        "052053" = "California Counties of Riversi"
        "052059" = "CA Counties of San Mateo etc"
        "052060" = "California Counties of Marin "
        "052063" = "California Counties of San Lui"
        "052067" = "California Counties of Calaver"
        "052103" = "DC MD and VA "
        "052115" = "Florida Counties of Baker Cla"
        "052119" = "Florida Counties"
        "052125" = "Florida Counties of Charlotte"
        "052126" = "Florida Counties of Charlotte"
        "052133" = "Georgia Counties of Banks Bar"
        "052137" = "AL and GA Counties 1"
        "052138" = "AL and GA Counties 2"
        "052141" = "Georgia Counties of Appling B"
        "052153" = "HI Statewide 1"
        "052154" = "HI Statewide 2"
        "052159" = "Idaho Statewide"
        "052177" = "IL Counties 1"
        "052178" = "IL Counties 2"
        "052183" = "Illinois Counties of Edwards "
        "052187" = "Indiana Counties of Perry Pos"
        "052193" = "Indiana Counties of Bartholome"
        "052223" = "Indiana Counties of Clark Flo"
        "052231" = "LA Parishes 1"
        "052232" = "LA Parishes 2"
        "052247" = "Maryland Counties of Anne Arun"
        "052255" = "Massachusetts county"
        "052259" = "Massachusetts County"
        "052269" = "Michigan Counties of Lenawee "
        "052271" = "Michigan Counties of Alcona A"
        "052285" = "Minnesota Counties of Aitkin "
        "052287" = "MN and WI 1"
        "052288" = "MN and WI 2"
        "052289" = "Minnesota Counties of Benton "
        "052299" = "Alabama County of Sumter"
        "052307" = "Kansas Counties of Anderson A"
        "052317" = "Montana Statewide"
        "052325" = "Iowa Counties of Adams Buena "
        "052355" = "New Jersey County of Mercer"
        "052367" = "New York Counties of Albany C"
        "052377" = "New York Counties of Clinton "
        "052393" = "North Carolina Counties of Bea"
        "052417" = "OH Counties 1"
        "052418" = "OH Counties 2"
        "052433" = "Oklahoma Counties of Adair Ch"
        "052451" = "Ohio Counties of Belmont Harr"
        "052475" = "South Carolina Counties of Cal"
        "052485" = "SD Counties 1"
        "052486" = "SD Counties 2"
        "052503" = "Texas Counties of Bastrop Bla"
        "052511" = "NM and TX Counties 1"
        "052512" = "NM and TX Counties 2"
        "052513" = "Texas Counties of Erath Hood"
        "052517" = "NM OK and TX Counties 1"
        "052518" = "NM OK and TX Counties 2"
        "052523" = "Texas Counties of Anderson Be"
        "052525" = "Oklahoma Counties of Comanche"
        "052545" = "Virginia Counties of Albemarle"
        "052565" = "Yakima WA"
        "052567" = "Washington Counties of Lewis "
        "052569" = "Oregon Counties of Baker Gran"
        "052577" = "Wisconsin Counties of Adams B"
        "052579" = "Wisconsin Counties of Columbia"
        "052587" = "Nebraska Counties of Banner B"
        "053023" = "CT New London County 1"
        "053024" = "CT New London County 2"
        "154201" = "New Jersey County of Mercer"
        "154281" = "District of Columbia MD and VA"
        "155637" = "California Counties of Marin "
        "155638" = "CA Counties of SFO & San Mateo"
        "AL01"   = "AL Residence Offices"
        "AL02"   = "Ft. Rucker - Operating Site"
        "AR01"   = "Arkansas"
        "ARE1"   = "United Arab Emmirates"
        "AUS1"   = "Australia - Int'l Field Office"
        "AZ01"   = "AZ Residence Offices"
        "BRT1"   = "Beirut - Intl Field Office"
        "CA01"   = "Menlo Park CA - Headquarters"
        "CA04"   = "Santa Maria CA -Operating Site"
        "CA05"   = "Vandenberg AFB -Operating Site"
        "CA07"   = "Los Banos CA - Operating Site"
        "CA08"   = "Tracy CA -Operating Site(CHES)"
        "CA10"   = "San Luis Obispo - Field Office"
        "CA12"   = "Huntington Beach"
        "CA19"   = "San Diego - Field Office"
        "CA20"   = "CA Residence Offices"
        "CA21"   = "Mountain View - Operating Site"
        "CA22"   = "Fremont - Field Office"
        "CA23"   = "Hat Creek Radio Observatory"
        "CA24"   = "CA Residence Offices 1"
        "CA25"   = "CA Residence Offices 3"
        "CHE"    = "Switzerland - Intl Field Ofc"
        "CO01"   = "Aurora - Operating Site"
        "CO03"   = "CO Residence Offices"
        "CO04"   = "Boulder"
        "CO05"   = "CO Residence Offices 3"
        "CT01"   = "CT Residence Offices"
        "CT02"   = "Pawcatuck - Field Office"
        "DE01"   = "DE Residence Offices"
        "FL01"   = "Tampa - Operating Site"
        "FL03"   = "Orlando - Operating Site"
        "FL04"   = "St. Petersburg"
        "FL05"   = "FL Residence Offices"
        "FL06"   = "Eglin AFB - Operating Site"
        "FL07"   = "Largo - Field Office"
        "GA01"   = "GA Residence Offices"
        "GLD1"   = "Greenland - Intl Field Office"
        "HI01"   = "HI Residence Offices"
        "IA01"   = "IA - Residence Offices"
        "ID01"   = "ID Residence Offices"
        "ID02"   = "Gowen Field - Operating Site"
        "IL01"   = "IL Residence Offices"
        "IL02"   = "IL Residence Offices 2"
        "IN01"   = "IN - Residence Offices"
        "IRQ1"   = "Bagdad - Intl Field Office"
        "JPN1"   = "Japan - Intl Field Office"
        "KS02"   = "KS Residence Offices"
        "KY01"   = "KY - Operating Site"
        "KY02"   = "KY Residence Office"
        "LA01"   = "LA - Residence Offices"
        "MA01"   = "MA Residence Offices"
        "MA02"   = "MA Residence Offices 3"
        "MD01"   = "Lexington Park - Field Office"
        "MD02"   = "MD Residence Offices"
        "MD03"   = "US Army APG Maryland"
        "MD04"   = "Havre de Grace - Field Office"
        "ME01"   = "ME Residence Offices"
        "MI01"   = "MI Residence Offices"
        "MI02"   = "MI Ann Arbor Field Office"
        "MI03"   = "Plymouth- Field Office"
        "MN01"   = "MN Residence Offices"
        "MN02"   = "Camp Ripley - Operating Site"
        "MO01"   = "Missouri Residence"
        "MS01"   = "Camp Shelby - Operating Site"
        "MT01"   = "Helena - Field Office"
        "MT02"   = "MT Residence Office"
        "NC01"   = "NC Residence Offices"
        "NC02"   = "NC Residence Offices 2"
        "ND01"   = "ND Residence Offices"
        "NH01"   = "NH Residence Offices"
        "NJ02"   = "Ft. Monmouth - Operating Site"
        "NJ03"   = "NJ Residence Offices"
        "NJ04"   = "Shrewsbury - Field Office"
        "NJ05"   = "Princeton - Field Office"
        "NM01"   = "Kirtland AFB - Operating Site"
        "NM03"   = "NM Residence Offices"
        "NV01"   = "NV Residence Offices"
        "NY02"   = "NY Residence Offices"
        "NY03"   = "New York - Field Office"
        "NY04"   = "NY Residence Offices 1"
        "NY05"   = "NY Residecne Offices 2"
        "OH01"   = "OH Residence Offices"
        "OK01"   = "OK Residence Offices"
        "OR01"   = "OR Residence Offices 2"
        "OR02"   = "OR Residence Offices 1"
        "PA01"   = "State College - Field Office"
        "PA02"   = "PA Residence Offices"
        "PR01"   = "PR - Arecibo Observatory"
        "RI01"   = "RI - Residence Offices"
        "SC01"   = "SC Residence Office"
        "TN01"   = "TN Residence Offices"
        "TX01"   = "San Antonio AFB - Op Site"
        "TX02"   = "Austin - Operating Site"
        "TX03"   = "Ft. Hood - Operating Site"
        "TX05"   = "TX Residence Offices"
        "TX06"   = "Camp Bowie AFB-Operating Site"
        "TX07"   = "Lackland AFB - Operating Site"
        "TX08"   = "San Antonio Field Office"
        "TX09"   = "TX Residence Offices 2"
        "UT01"   = "UT Residence Offices"
        "VA01"   = "Washington D.C. - Field Office"
        "VA02"   = "VA Residence Offices"
        "VA03"   = "Ft. Pickett - Operating Site"
        "VA04"   = "Shenandoah Valley"
        "VT01"   = "VT Residence Offices"
        "WA01"   = "WA Residence Offices"
        "WA02"   = "WA Residence Offices"
        "WI02"   = "WI Residence Offices"
        "WV01"   = "WV Residence Offices"

    }
    write-host "`n Getting users from AD ... this might take awhile `n "
    # $users = (Get-ADUser -Filter { Name -like "Barry Brosnon" }  -SearchBase "OU=People,DC=SRI,DC=COM" -properties *).jpegPhoto | set-content './user_photos/photo.jpeg' -AsByteStream`
    # $users = Get-ADUser -Filter { Name -like "Barry Brosnon" }  -SearchBase "OU=People,DC=SRI,DC=COM" -properties * | select sriDepartmentName
    $users = Get-ADUser -Filter { Name -like "*" }   -SearchBase "OU=People,DC=SRI,DC=COM" -properties name, mail, departmentnumber, sriDepartmentName, division, title, uid, manager, officephone, otherTelephone, fax, office, city, jpegPhoto |`
        Select-Object `
    @{N = "name"; E = { $_.name } }, `
        mail, `
        email, `
    @{N = "division"; E = { $_.division } }, `
    @{N = "sriDepartmentName"; E = { $_.sriDepartmentName.substring(8) } }, `
    @{N = "title"; E = { $_.title } }, `
        eid, `
        departmentnumber, `
        samAccountName, `
    @{N = "manager"; E = { $_.manager } }, `
    @{N = "department"; E = { $_.department } }, `
        officePhone, `
        phone, `
    @{N = "fax"; E = { $_.fax } }, `
        otherTelephone, `
        altPhone, `
    @{N = "office"; E = { $_.office } }, `
        city, `
        location, `
        image, `
        jpegPhoto


    $users | ForEach-Object { 
                
        try {
            if ($_.name -ne $null) { $_.name = $_.name }else { $_.name = "" }
            if ($_.mail -ne $null) { $_.email = $_.mail }else { $_.email = "" }
            if ($_.departmentNumber -ne $null) { $_.departmentNumber = $_.departmentNumber.trim('{') }else { $_.departmentNumber = "" }
            if ($_.division -ne $null) { $_.division = $_.division }else { $_.division = "" }
            if ($_.sriDepartmentName -ne $null) { $_.department = $_.sriDepartmentName }else { $_.department = "" }
            if ($_.samAccountName -ne $null) { $_.eid = $_.samAccountName }else { $_.eid = "" }
            if ($_.title -ne $null) { $_.title = $_.title }else { $_.title = "" }
            if ($_.eid -ne $null) { $_.eid = $_.eid }else { $_.eid = "" }
            if ($_.manager -ne $null) { $_.manager = $_.manager }else { $_.manager = "" }
            if ($_.officephone -ne $null) { $_.phone = $_.officephone }else { $_.phone = "" }
            if ($_.otherTelephone -ne $null) { $_.altphone = $_.otherTelephone.trim('{') }else { $_.altphone = "" }
            if ($_.fax -ne $null) { $_.fax = $_.fax }else { $_.fax = "" }
            if ($_.office -ne $null) { $_.office = $_.office }else { $_.office = "" }
            if ($_.city -ne $null) { $_.location = $sriDepartmentName[$_.city] }else { $_.location = "Remote" }
            if ($_.location -ne $null) { $_.location = $_.location }else { $_.location = "" }
            if ($_.mail -ne $null ) { $_.image = "https://sriintl.sharepoint.us/sites/Insider/_layouts/15/userphoto.aspx?size=M&accountname=" + $_.mail.replace('@', '%40') }else { $_.image = "" }
            # if ($_.jpegPhoto -ne $null){ $_.jpegPhoto | set-content -path "./user_ADphotos/$($_.name)_.jpeg" -AsByteStream }else{
                        
            #     Write-Host "$($_.name) does not have a photo ... adding default photo instead"
                    
            #     # set default photo
            #     Copy-Item "./default_photo.png" "./user_ADphotos/$($_.name)_.jpeg"
            # }
        }
        catch {
            write-host ` error occured with $($_.name) ...`
        }
        Finally {
            # write-host ` $($_.name) completed ...`
        }
    }
    write-host "`n Writing user Objects to userObjArray.json ... `n "
    $users | select-object name, email, departmentnumber, division, department, title, eid, manager, phone, altphone, fax, office, location, image | ConvertTo-Json | Out-File .\usersObjArray.json
    write-host "`n Success! `n "
    # $users | select-object name, email, departmentNumber, division, department, title, eid, manager, phone, altphone, fax, office, location, image | Export-Csv -path .\Users.csv

    # '<script type="text/javascript"> var people = ' + (get-content .\Users.json) + ";</script>" | set-content toUploadUsers.json


    
}



