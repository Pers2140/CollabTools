
$clientAppId = "7c09c877-8503-4246-890c-a036cd382792"; #client-app

$tenantPrefix = "sriitdev2"; # replace with your tenant id TODO to replace
$tenantName = $tenantPrefix +".onmicrosoft.com";
$password = (ConvertTo-SecureString -AsPlainText 'pass@word1' -Force)

$site2apply = "https://sriitdev2.sharepoint.com/sites/AD_profileinfo/"

$clientConn = Connect-PnPOnline -Url $site2apply -ClientId $clientAppId -CertificatePath './clientpnpSites-Selected.pfx' -CertificatePassword $password  -Tenant $tenantName

# Get-PnPList

#### GET
$perms = Get-PnPAzureADAppSitePermission -Site $site2apply

#### SET
Set-PnPAzureADAppSitePermission -Site $site2apply -Permissions Write -PermissionId $perms.Id